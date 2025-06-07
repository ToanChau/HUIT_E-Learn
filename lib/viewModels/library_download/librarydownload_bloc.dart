import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/repositories/document_repository.dart';
import 'package:huit_elearn/viewModels/library_download/librarydownload_event.dart';
import 'package:huit_elearn/viewModels/library_download/librarydownload_state.dart';

class LibrarydownloadBloc
    extends Bloc<LibrarydownloadEvent, LibrarydownloadState> {
  final DocumentRepository documentRepository = DocumentRepository();

  LibrarydownloadBloc() : super(LibrarydownloadInitialState()) {
    on<LibrarydownloadInitialEvent>((
      LibrarydownloadInitialEvent event,
      Emitter<LibrarydownloadState> emit,
    ) {
      emit(LibrarydownloadInitialState());
    });
    on<LibrarydownloadStartEvent>(_onDownloadStart);
  }
  void _onDownloadStart(
    LibrarydownloadStartEvent event,
    Emitter<LibrarydownloadState> emit,
  ) async {
    try {
      await documentRepository.downloadDocument(event.document, (progress, _) {
        emit(LibrarydownloadingState(progress: progress));
      });

      emit(LibrarydownloadComplete());
    } catch (e) {
      emit(Librarydownloadfailed());
    }
  }
}
