import 'package:equatable/equatable.dart';
import 'package:huit_elearn/models/documents.dart';

class LibraryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LibraryInitialEvent extends LibraryEvent {
  @override
  List<Object?> get props => [];
}

class LibraryChoseAcceptedDocEvent extends LibraryEvent {
  final String maNguoiDung;
  LibraryChoseAcceptedDocEvent({required this.maNguoiDung});
  @override
  List<Object?> get props => [maNguoiDung];
}

class LibraryChoseUnAcceptedDocEvent extends LibraryEvent {
  final String maNguoiDung;
  LibraryChoseUnAcceptedDocEvent({required this.maNguoiDung});
  @override
  List<Object?> get props => [maNguoiDung];
}

class LibraryChoseDocEvent extends LibraryEvent {
  final Document doc;
  LibraryChoseDocEvent({required this.doc});
}

class LibrarySearchingEvent extends LibraryEvent {
  final String query;
  LibrarySearchingEvent({required this.query});
  @override
  List<Object?> get props => [query];
}
