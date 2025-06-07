// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:equatable/equatable.dart';

import 'package:huit_elearn/models/documents.dart';
import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/models/subjects.dart';

class DocEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DocInitialEvent extends DocEvent {}

class DocLoadingEvent extends DocEvent {}

class DocSearchEvent extends DocEvent {
  final String searchQuery;

  DocSearchEvent({required this.searchQuery});

  @override
  // TODO: implement props
  List<Object?> get props => [searchQuery];
}

class DocChoseDetailFacultyEvent extends DocEvent {
  Faculty faculty;
  DocChoseDetailFacultyEvent({required this.faculty});
}

class DocChoseFacultyEvent extends DocEvent {
  Faculty faculty;
  DocChoseFacultyEvent({required this.faculty});
}

class DocChoseDetailSubjectEvent extends DocEvent {
  Faculty faculty;
  Subject subject;
  DocChoseDetailSubjectEvent({required this.faculty, required this.subject});
  @override
  List<Object?> get props => [faculty, subject];
}

class DocChoseSubjecEvent extends DocEvent {
  Faculty faculty;
  Subject subject;
  DocChoseSubjecEvent({required this.faculty, required this.subject});
}

class DocChoseDocEvent extends DocEvent {
  Faculty faculty;
  Subject subject;
  Document document;
  DocChoseDocEvent({
    required this.faculty,
    required this.subject,
    required this.document,
  });
}

class DocDownloadEvent extends DocEvent {
  final Document document;

  DocDownloadEvent({required this.document});

  @override
  List<Object?> get props => [document];
}

class SearchOnSearchScreenEvent extends DocEvent {
  @override
  List<Object?> get props => [];
}

class SearchChoseDocEvent extends DocEvent {
  Document document;
  SearchChoseDocEvent({required this.document});
  @override
  // TODO: implement props
  List<Object?> get props => [document];
}

class VoteDocEvent extends DocEvent {
  Document document;
  VoteDocEvent({required this.document});

  @override
  // TODO: implement props
  List<Object?> get props => [document];
}

class SendReport extends DocEvent {
 final Document document;
  final String noiDung;
  final String maNguoiDung;
  
  SendReport({
    required this.document,
    required this.noiDung,
    required this.maNguoiDung,
  });
  
  @override
  List<Object?> get props => [document, noiDung, maNguoiDung];
}
