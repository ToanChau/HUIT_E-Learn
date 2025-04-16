import 'package:equatable/equatable.dart';
import 'package:huit_elearn/models/documents.dart';

class LibraryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LibraryInitialState extends LibraryState {
  @override
  List<Object?> get props => [];
}

class LibraryLodingState extends LibraryState {
  @override
  List<Object?> get props => [];
}

class LibraryErrorState extends LibraryState {
  final String message;
  LibraryErrorState({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}

class LibraryChoseUnAcceptedState extends LibraryState {
  final List<Document> documents;
  LibraryChoseUnAcceptedState({required this.documents});
  @override
  List<Object?> get props => [documents];
}

class LibraryChoseAcceptedState extends LibraryState {
  final List<Document> documents;
  LibraryChoseAcceptedState({required this.documents});
  @override
  List<Object?> get props => [documents];
}
