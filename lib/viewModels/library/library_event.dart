// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

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
  LibraryChoseAcceptedDocEvent({
    required this.maNguoiDung,
  });
  @override
  List<Object?> get props => [maNguoiDung];
}

class LibraryChoseUnAcceptedDocEvent extends LibraryEvent {
  final String maNguoiDung;
  LibraryChoseUnAcceptedDocEvent({
    required this.maNguoiDung,
  });
  @override
  List<Object?> get props => [maNguoiDung];
}
