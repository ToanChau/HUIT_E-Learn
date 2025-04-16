// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/models/subjects.dart';
import 'package:huit_elearn/models/tests.dart';

abstract class CreatetestEvent extends Equatable {}

class CreateTestInitialEvent extends CreatetestEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ChoseFacultyEvent extends CreatetestEvent {
  final Faculty faculty;

  ChoseFacultyEvent(this.faculty);

  @override
  // TODO: implement props
  List<Object?> get props => [Faculty];
}

class ChoseSubjectEvent extends CreatetestEvent {
  final Subject subject;
  final String userID;
  final Faculty faculty;

  ChoseSubjectEvent({
    required this.subject,
    required this.userID,
    required this.faculty,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [subject, userID];
}

class CreateTestLoading extends CreatetestEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChoseTestEvent extends CreatetestEvent {
  final Test test;
  final Subject subject;
  final Faculty faculty;

  ChoseTestEvent(this.test, this.subject, this.faculty);

  @override
  // TODO: implement props
  List<Object?> get props => [test];
}

class ChoseCreateTestEvent extends CreatetestEvent {
  final String useId;
  final Subject subject;
  final Faculty faculty;
  ChoseCreateTestEvent({
    required this.subject,
    required this.faculty,
    required this.useId,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [subject, faculty];
}

class CreatingNomalTestEvent extends CreatetestEvent {
  final String testName;
  final String useId;
  final String level;
  final Subject subject;
  final Faculty faculty;
  CreatingNomalTestEvent({
    required this.testName,
    required this.level,
    required this.subject,
    required this.faculty,
    required this.useId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [subject, faculty, useId, testName,level];
}
class CreatingAITestEvent extends CreatetestEvent {
  final String testName;
  final String useId;
  final String level;
  final Subject subject;
  final Faculty faculty;
  CreatingAITestEvent({
    required this.testName,
    required this.level,
    required this.subject,
    required this.faculty,
    required this.useId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [subject, faculty, useId, testName,level];
}
class CreatingRAGTestEvent extends CreatetestEvent {
  final String testName;
  final String useId;
  final String level;
  final Subject subject;
  final Faculty faculty;
  
  CreatingRAGTestEvent({
    required this.testName,
    required this.level,
    required this.subject,
    required this.faculty,
    required this.useId,
  });

  @override
  List<Object?> get props => [subject, faculty, useId, testName, level];
}
