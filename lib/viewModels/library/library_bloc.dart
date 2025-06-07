import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:huit_elearn/models/documents.dart';
import 'package:huit_elearn/repositories/document_repository.dart';
import 'package:huit_elearn/viewModels/library/library_event.dart';
import 'package:huit_elearn/viewModels/library/library_state.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final DocumentRepository documentRepository = DocumentRepository();
  LibraryBloc() : super(LibraryInitialState()) {
    on<LibraryChoseAcceptedDocEvent>(_onChoseAccepted);
    on<LibraryChoseUnAcceptedDocEvent>(_onChoseUnAccepted);
    on<LibraryChoseDocEvent>(_onChoseDoc);
    on<LibrarySearchingEvent>(_onSearching);
  }
  void _onChoseAccepted(
    LibraryChoseAcceptedDocEvent event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLodingState());
    try {
      final doc = await documentRepository.getAcceptedDocument(
        event.maNguoiDung,
      );
      emit(LibraryChoseAcceptedState(documents: doc));
    } catch (e) {
      emit(LibraryErrorState(message: e.toString()));
    }
  }

  void _onChoseUnAccepted(
    LibraryChoseUnAcceptedDocEvent event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLodingState());
    try {
      final doc = await documentRepository.getUnAcceptedDocument(
        event.maNguoiDung,
      );
      emit(LibraryChoseUnAcceptedState(documents: doc));
    } catch (e) {
      emit(LibraryErrorState(message: e.toString()));
    }
  }

  void _onChoseDoc(
    LibraryChoseDocEvent event,
    Emitter<LibraryState> emit,
  ) async {
    final url = event.doc.uRL;
    final fileName = url.split('/').last;

    try {
      emit(LibraryLodingState());

      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      emit(LibraryChoseDocState(filePath: file));
      // final result = await OpenFile.open(file.path);
    } catch (e) {
      emit(LibraryErrorState(message: "Lỗi khi mở tài liệu: $e"));
    }
  }

  void _onSearching(
  LibrarySearchingEvent event,
  Emitter<LibraryState> emit,
) async {
  final currentState = state;
  List<Document> sourceDocument = [];
  
  if (currentState is LibraryChoseAcceptedState) {
    sourceDocument = currentState.documents;
  } else if (currentState is LibraryChoseUnAcceptedState) {
    sourceDocument = currentState.documents;
  } else if (currentState is LibrarySearchState) {
    sourceDocument = currentState.fulldocuments;
  }

  final query = event.query.toLowerCase();
  
  if (query.isEmpty) {
    if (currentState is LibrarySearchState) {
      if (currentState.originalState is LibraryChoseAcceptedState) {
        emit(LibraryChoseAcceptedState(documents: sourceDocument));
      } else if (currentState.originalState is LibraryChoseUnAcceptedState) {
        emit(LibraryChoseUnAcceptedState(documents: sourceDocument));
      }
    }
    return;
  }
  
  final filter = sourceDocument
      .where((doc) => doc.tenTaiLieu.toLowerCase().contains(query))
      .toList();
  
  emit(
    LibrarySearchState(
      fulldocuments: sourceDocument,
      documents: filter,
      query: event.query,
      originalState: currentState is LibrarySearchState 
          ? currentState.originalState 
          : currentState,
    ),
  );
}
}
