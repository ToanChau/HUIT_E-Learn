import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/viewModels/taketest/taketest_event.dart';
import 'package:huit_elearn/viewModels/taketest/taketest_state.dart';

class TaketestBloc extends Bloc<TaketestEvent, TaketestState> {

  TaketestBloc() : super(TaketestInitialState()) {
    on<LoadQuestionsEvent>(_onLoadQuestions);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<FinishTestEvent>(_onFinishTest);
  }

  void _onLoadQuestions(
      LoadQuestionsEvent event, Emitter<TaketestState> emit) async {
    emit(TaketestLoadingState());
    try {
      final questions = event.questions;
      final userAnswers = List<String?>.filled(questions.length, null);
      final correctAnswers = List<bool?>.filled(questions.length, null);

      emit(TaketestLoadedState(
        faculty: event.faculty,
        questions: questions,
        test: event.test,
        subject: event.subject,
        currentIndex: 0,
        userAnswers: userAnswers,
        correctAnswers: correctAnswers,
        score: 0,
      ));
    } catch (e) {
      emit(TaketestErrorState(errorMessage: 'Không thể tải câu hỏi: $e'));
    }
  }

  void _onAnswerQuestion(
      AnswerQuestionEvent event, Emitter<TaketestState> emit) {
    if (state is TaketestLoadedState) {
      final currentState = state as TaketestLoadedState;
      final userAnswers = List<String?>.from(currentState.userAnswers);
      final correctAnswers = List<bool?>.from(currentState.correctAnswers);

      userAnswers[currentState.currentIndex] = event.answer;
      correctAnswers[currentState.currentIndex] = event.isCorrect;

      emit(TaketestLoadedState(
        faculty: currentState.faculty,
        questions: currentState.questions,
        test: currentState.test,
        subject: currentState.subject,
        currentIndex: currentState.currentIndex,
        userAnswers: userAnswers,
        correctAnswers: correctAnswers,
        score: currentState.score,
        selectedAnswer: event.answer,
        isCurrentAnswerCorrect: event.isCorrect,
      ));
    }
  }

  void _onNextQuestion(
      NextQuestionEvent event, Emitter<TaketestState> emit) {
    if (state is TaketestLoadedState) {
      final currentState = state as TaketestLoadedState;
      
      int newScore = currentState.score;
      if (currentState.isCurrentAnswerCorrect ?? false) {
        newScore += 1;
      }

      if (currentState.currentIndex < currentState.questions.length - 1) {
        emit(TaketestLoadedState(
          faculty: currentState.faculty,
          questions: currentState.questions,
          test: currentState.test,
          subject: currentState.subject,
          currentIndex: currentState.currentIndex + 1,
          userAnswers: currentState.userAnswers,
          correctAnswers: currentState.correctAnswers,
          score: newScore,
          selectedAnswer: null,
          isCurrentAnswerCorrect: null,
        ));
      } else {
        emit(TaketestCompletedState(
          faculty: currentState.faculty,
          questions: currentState.questions,
          test: currentState.test,
          subject: currentState.subject,
          userAnswers: currentState.userAnswers,
          correctAnswers: currentState.correctAnswers,
          score: newScore,
          totalQuestions: currentState.questions.length,
        ));
      }
    }
  }

  void _onFinishTest(FinishTestEvent event, Emitter<TaketestState> emit) {
    if (state is TaketestLoadedState) {
      final currentState = state as TaketestLoadedState;
      
      int finalScore = 0;
      for (int i = 0; i < currentState.correctAnswers.length; i++) {
        if (currentState.correctAnswers[i] ?? false) {
          finalScore += 1;
        }
      }
      
      emit(TaketestCompletedState(
        faculty: currentState.faculty,
        questions: currentState.questions,
        test: currentState.test,
        subject: currentState.subject,
        userAnswers: currentState.userAnswers,
        correctAnswers: currentState.correctAnswers,
        score: finalScore,
        totalQuestions: currentState.questions.length,
      ));
    }
  }
}