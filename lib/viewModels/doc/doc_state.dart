// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:huit_elearn/models/documents.dart';
import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/models/lecturer.dart';
import 'package:huit_elearn/models/subjects.dart';

class DocState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class DocInitialState extends DocState {
  @override
  List<Object?> get props => [];
}

class DocErrorState extends DocState {
  final String message;
  DocErrorState({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class DocLoadingState extends DocState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DocLoadedState extends DocState {
  final List<Faculty> faculties;
  DocLoadedState(this.faculties);
  @override
  // TODO: implement props
  List<Object?> get props => faculties;
}

class DocChoseDetailFaculty extends DocState {
  final Faculty faculty;
  final List<Lecturer> lecturers;
  DocChoseDetailFaculty({required this.faculty, required this.lecturers});
  @override
  // TODO: implement props
  List<Object?> get props => [faculty];
}

class DocChoseFaculty extends DocState {
  final Faculty faculty;
  final List<Subject> subjects;
  DocChoseFaculty({required this.faculty, required this.subjects});
  @override
  // TODO: implement props
  List<Object?> get props => [faculty, subjects];
}

class DocChoseDetailSubject extends DocState {
  final Faculty faculty;
  final Subject subject;
  DocChoseDetailSubject({required this.faculty, required this.subject});
  @override
  // TODO: implement props
  List<Object?> get props => [faculty, subject];
}

class DocChoseSubject extends DocState {
  final Faculty faculty;
  final Subject subject;
  final List<Document> documents;
  DocChoseSubject({
    required this.faculty,
    required this.subject,
    required this.documents,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [faculty, subject, documents];
}

class DocChoseDoc extends DocState {
  final Faculty faculty;
  final Subject subject;
  final Document document;

  DocChoseDoc({
    required this.faculty,
    required this.subject,
    required this.document,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [faculty, subject, document];
}

class DocDownloadingState extends DocState {
  final Document document;
  final double progress;
  final double remainingSeconds;
  final Faculty faculty;
  final Subject subject;

  DocDownloadingState({
    required this.document,
    required this.progress,
    required this.remainingSeconds,
    required this.faculty,
    required this.subject,
  });

  @override
  List<Object?> get props => [
    document,
    progress,
    remainingSeconds,
    faculty,
    subject,
  ];
}

class DocDownloadCompleteState extends DocState {
  final Document document;
  final Faculty faculty;
  final Subject subject;

  DocDownloadCompleteState({
    required this.document,
    required this.faculty,
    required this.subject,
  });

  @override
  List<Object?> get props => [document, faculty, subject];
}

class DocSearchState extends DocState {
  final List<Faculty> faculties;
  final String searchQuery;
  DocSearchState({required this.faculties, required this.searchQuery});
  @override
  // TODO: implement props
  List<Object?> get props => [faculties, searchQuery];
}

class DocSearchFacultyState extends DocState {
  final Faculty faculty;
  final List<Subject> subjects;
  final String searchQuery;
  DocSearchFacultyState({
    required this.faculty,
    required this.subjects,
    required this.searchQuery,
  });
  @override
  List<Object?> get props => [faculty, subjects, searchQuery];
}

class DocSearchSubjectState extends DocState {
  final Faculty faculty;
  final Subject subject;
  final List<Document> documents;
  final String searchQuery;

  DocSearchSubjectState({
    required this.faculty,
    required this.subject,
    required this.documents,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [faculty, subject, documents, searchQuery];
}

class SearchScreenstate extends DocState {
  @override
  List<Object?> get props => [];
}

class SearchingonScreen extends DocState {
  final List<Document> documents;
  SearchingonScreen({required this.documents});
  @override
  List<Object?> get props => [documents];
}

class SearchChoseDocState extends DocState {
  final Document document;
  SearchChoseDocState({
    required this.document,
  });
  @override
  List<Object?> get props => [document];
}
