import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/repositories/document_repository.dart';
import 'package:huit_elearn/viewModels/library/library_event.dart';
import 'package:huit_elearn/viewModels/library/library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final DocumentRepository documentRepository = DocumentRepository();
  LibraryBloc() : super(LibraryInitialState()) {
    on<LibraryChoseAcceptedDocEvent>(_onChoseAccepted);
    on<LibraryChoseUnAcceptedDocEvent>(_onChoseUnAccepted);
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
  ) async{
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
}
