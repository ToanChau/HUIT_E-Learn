import 'package:equatable/equatable.dart';
import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/models/subjects.dart';
import 'package:huit_elearn/models/tests.dart';

abstract class TaketestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaketestInitial extends TaketestEvent {}

class LoadQuestionsEvent extends TaketestEvent {
  final List<Question> questions;
  final Test test;
  final Subject subject;
  final Faculty faculty;

  LoadQuestionsEvent({
    required this.questions,
    required this.test,
    required this.subject,
    required this.faculty,
  });

  @override
  List<Object?> get props => [questions, test, subject];
}

class AnswerQuestionEvent extends TaketestEvent {
  final String answer;
  final bool isCorrect;

  AnswerQuestionEvent({required this.answer, required this.isCorrect});

  @override
  List<Object?> get props => [answer, isCorrect];
}

class NextQuestionEvent extends TaketestEvent {}

class FinishTestEvent extends TaketestEvent {}
