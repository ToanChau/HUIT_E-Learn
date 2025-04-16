// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/models/subjects.dart';
import 'package:huit_elearn/models/tests.dart';

abstract class CreatetestState extends Equatable {}

class CreateTestInitialState extends CreatetestState {
  @override
  List<Object?> get props => [];
}

class CreateTestLoadedState extends CreatetestState {
  final List<Faculty> faculties;

  CreateTestLoadedState({required this.faculties});

  @override
  List<Object?> get props => [faculties];
}

class CreateTestLoadingState extends CreatetestState {
  @override
  List<Object?> get props => [];
}

class CreateTestErrorState extends CreatetestState {
  final String message;

  CreateTestErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChoseFacultyState extends CreatetestState {
  final Faculty faculty;
  final List<Subject> subjects;

  ChoseFacultyState({required this.faculty, required this.subjects});

  @override
  List<Object?> get props => [faculty, subjects];
}

class ChoseSubjectState extends CreatetestState {
  final List<Test> tests;
  final Subject currentSubject;
  final Faculty faculty;
  ChoseSubjectState(this.tests, this.currentSubject, this.faculty);
  @override
  // TODO: implement props
  List<Object?> get props => [tests, currentSubject];
}

class ChoseTestState extends CreatetestState {
  final List<Question> questions;
  final Test test;
  final Subject subject;
  final Faculty faculty;
  ChoseTestState({
    required this.questions,
    required this.test,
    required this.subject,
    required this.faculty,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [questions, test];
}

class ChoseCreateTestState extends CreatetestState {
  final String useID;
  final Subject subject;
  final Faculty faculty;
  ChoseCreateTestState({required this.subject, required this.faculty,required this.useID});

  @override
  // TODO: implement props
  List<Object?> get props => [subject, faculty,useID];
}

class CreatedgNomalTestState extends CreatetestState {
  final List<Question> questions;
  final Test test;
  final Subject subject;
  final Faculty faculty;
  CreatedgNomalTestState({
    required this.questions,
    required this.test,
    required this.subject,
    required this.faculty,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [questions,test,subject,subject,faculty];
}
