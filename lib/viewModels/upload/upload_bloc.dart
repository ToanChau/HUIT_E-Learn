// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/models/documents.dart';
import 'package:path/path.dart' as p;
import 'package:huit_elearn/repositories/document_repository.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/upload/upload_event.dart';
import 'package:huit_elearn/viewModels/upload/upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final DocumentRepository _documentRepository;
  StreamSubscription? _uploadSubscription;
  final AuthBloc _authBloc;
  UploadBloc({required documentRepository, required authBloc})
    : _documentRepository = documentRepository,
      _authBloc = authBloc,
      super(UploadInitialState()) {
    on<UploadInitial>((event, emit) {emit(UploadInitialState());});
    on<UploadStarted>(_onUploadStarted);
    on<UploadCancelled>(_onUploadCancelled);
    on<UploadDetailSubmitted>(_onUploadDetailSubmitted);
  }
  FutureOr<void> _onUploadStarted(
    UploadStarted event,
    Emitter<UploadState> emit,
  ) async {
    emit(UploadLoadingState());
    final filesize = await _documentRepository.getFileSize(event.file);
    final uploadResult = await _documentRepository.uploadFileWithProgress(
      event.file,
      event.FileName,
      (progress, remainingSeconds) {
        String remainingTime;
        if (remainingSeconds < 60) {
          remainingTime = 'Còn ${remainingSeconds.round()} giây';
        } else {
          remainingTime = 'Còn ${(remainingSeconds / 60).round()} phút';
        }
        emit(
          UploadProgressState(
            progress: progress,
            filename: event.FileName,
            remainingTime: remainingTime,
          ),
        );
      },
    );

    if (uploadResult == null) {
      emit(UploadCancelledState());
      return;
    }
    final documentId = _documentRepository.generateDocumentId();
    emit(
      UploadFileSuccessState(
        downloadURL: uploadResult,
        maTaiLieu: documentId,
        file: event.file,
        kichThuoc: filesize,
        tenTaiLieu: event.FileName,
      ),
    );
  }

  Future<void> _onUploadCancelled(
  UploadCancelled event,
  Emitter<UploadState> emit,
) async {
  try {
    
    if (state is UploadProgressState || state is UploadLoadingState) {
      await _documentRepository.cancelUpload();
    } else if (state is UploadFileSuccessState) {
      final currentState = state as UploadFileSuccessState;
      await _documentRepository.cancelUpload(url: currentState.downloadURL);
    }
    await _uploadSubscription?.cancel();

    if (event.isManualCancel) {
      emit(UploadCancelledState(message: "Tải lên đã bị hủy"));
    } else {
      emit(UploadInitialState());
    }
  } catch (e) {
    emit(UploadFailState(error: "Lỗi khi hủy tải lên: $e"));
  }
}

  Future<void> _onUploadDetailSubmitted(
    UploadDetailSubmitted event,
    Emitter<UploadState> emit,
  ) async {
    try {
      if (state is UploadFileSuccessState) {
        final currentState = state as UploadFileSuccessState;

        if (_authBloc.state is AuthAuthenticated) {
          final currentUser = _authBloc.state as AuthAuthenticated;
          final docRef = FirebaseFirestore.instance.collection('documents').doc();
    final docId = docRef.id;
          final document = Document(
            maTaiLieu: docId,
            tenTaiLieu: event.tenTaiLieu,
            ngayDang: DateTime.now(),
            nguoiDang: currentUser.user.maNguoiDung,
            moTa: event.moTa,
            kichThuoc: currentState.kichThuoc,
            loai: p.extension(currentState.file.path).replaceFirst(".", '').toLowerCase(),
            trangThai: "Chờ duyệt",
            maMH: event.maMH,
            uRL: currentState.downloadURL,
          );
          await _documentRepository.saveDocumentDetails(document);
          emit(UploadDetailSuccessState());
        } else {
          emit(UploadFailState(error: "Hãy đăng nhập trước khi tải lên"));
        }
      } else {
        emit(UploadFailState(error: "Trạng thái tải lên không hợp lệ"));
      }
    } catch (e) {}
  }
}
