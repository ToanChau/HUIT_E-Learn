// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

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
  LibraryErrorState({required this.message});
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

class LibraryChoseDocState extends LibraryState {
  final File filePath;
  LibraryChoseDocState({required this.filePath});
  @override
  List<Object?> get props => [filePath];
}

class LibrarySearchState extends LibraryState {
  final List<Document> documents;
  final List<Document> fulldocuments;
  final String query;
  final LibraryState originalState;
  LibrarySearchState({
    required this.fulldocuments,
    required this.documents,
    required this.query,
    required this.originalState,
  });
  @override
  List<Object?> get props => [fulldocuments,documents, query, originalState];
}
