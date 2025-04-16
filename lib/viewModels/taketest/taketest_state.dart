// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/models/subjects.dart';
import 'package:huit_elearn/models/tests.dart';

abstract class TaketestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaketestInitialState extends TaketestState {}

class TaketestLoadingState extends TaketestState {}

class TaketestLoadedState extends TaketestState {
  final List<Question> questions;
  final Test test;
  final Subject subject;
  final int currentIndex;
  final Faculty faculty;
  final List<String?> userAnswers;
  final List<bool?> correctAnswers;
  final int score;
  final String? selectedAnswer;
  final bool? isCurrentAnswerCorrect;

  TaketestLoadedState({
    required this.questions,
    required this.test,
    required this.subject,
    required this.faculty,
    required this.currentIndex,
    required this.userAnswers,
    required this.correctAnswers,
    required this.score,
    this.selectedAnswer,
    this.isCurrentAnswerCorrect,
  });

  @override
  List<Object?> get props => [
    questions,
    test,
    subject,
    currentIndex,
    userAnswers,
    correctAnswers,
    score,
    selectedAnswer,
    isCurrentAnswerCorrect,
  ];
}

class TaketestCompletedState extends TaketestState {
  final List<Question> questions;
  final Test test;
  final Subject subject;
  final Faculty faculty;
  final List<String?> userAnswers;
  final List<bool?> correctAnswers;
  final int score;
  final int totalQuestions;

  TaketestCompletedState({
    required this.questions,
    required this.test,
    required this.subject,
    required this.faculty,
    required this.userAnswers,
    required this.correctAnswers,
    required this.score,
    required this.totalQuestions,
  });

  @override
  List<Object?> get props => [
    questions,
    test,
    subject,
    userAnswers,
    correctAnswers,
    score,
    totalQuestions,
  ];
}

class TaketestErrorState extends TaketestState {
  final String errorMessage;

  TaketestErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
