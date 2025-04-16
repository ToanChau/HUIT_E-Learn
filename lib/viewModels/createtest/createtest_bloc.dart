import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/ai/question_generator.dart';
import 'package:huit_elearn/ai/rag_service.dart';
import 'package:huit_elearn/models/tests.dart';
import 'package:huit_elearn/repositories/faculty_repository.dart';
import 'package:huit_elearn/repositories/question_respository.dart';
import 'package:huit_elearn/repositories/subject_repository.dart';
import 'package:huit_elearn/repositories/test_repository.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_event.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_state.dart';

class CreatetestBloc extends Bloc<CreatetestEvent, CreatetestState> {
  final FacultyRepository facultyRepository;
  final SubjectRepository subjectRepository;
  final TestRepository testRepository;
  final QuestionRespository questionRespository;
  final RagService ragService = RagService();
  CreatetestBloc({
    required this.facultyRepository,
    required this.subjectRepository,
    required this.testRepository,
    required this.questionRespository,
  }) : super(CreateTestInitialState()) {
    on<CreateTestInitialEvent>(_onInitial);
    on<ChoseFacultyEvent>(_onChoseFaculty);
    on<ChoseSubjectEvent>(_onChoseSubject);
    on<ChoseTestEvent>(_onChoseTest);
    on<ChoseCreateTestEvent>(_onChoseCreateTest);
    on<CreatingNomalTestEvent>(_onChoseCreatingNomal);
    on<CreatingAITestEvent>(_onChoseCreatingWithAI);
    on<CreatingRAGTestEvent>(_onChoseCreatingWithRAG);
  }

  void _onInitial(
    CreateTestInitialEvent event,
    Emitter<CreatetestState> emit,
  ) async {
    try {
      final faculties = await facultyRepository.getAllFaculties();
      emit(CreateTestLoadedState(faculties: faculties));
    } catch (e) {
      emit(CreateTestErrorState(message: 'Không thể tải danh sách khoa'));
    }
  }

  void _onChoseFaculty(
    ChoseFacultyEvent event,
    Emitter<CreatetestState> emit,
  ) async {
    emit(CreateTestLoadingState());
    try {
      final subjects = await subjectRepository.getSubjectsByFaculty(
        event.faculty.maKhoa,
      );
      emit(ChoseFacultyState(faculty: event.faculty, subjects: subjects));
    } catch (e) {
      emit(CreateTestErrorState(message: 'Không thể tải môn học của khoa'));
    }
  }

  void _onChoseSubject(
    ChoseSubjectEvent event,
    Emitter<CreatetestState> emit,
  ) async {
    emit(CreateTestLoadingState());
    try {
      final tests = await testRepository.getAllTestByUserIDandMaMon(
        event.userID,
        event.subject.maMH,
      );
      emit(ChoseSubjectState(tests, event.subject, event.faculty));
    } catch (e) {
      emit(
        CreateTestErrorState(message: 'Không thể tải Bài kiểm tra của môn học'),
      );
    }
  }

  void _onChoseTest(ChoseTestEvent event, Emitter<CreatetestState> emit) async {
    emit(CreateTestLoadingState());
    try {
      final questions = await questionRespository.getQuestionsByTestId(
        event.test.maDe,
      );

      if (questions.isNotEmpty) {
        emit(
          ChoseTestState(
            questions: questions,
            test: event.test,
            subject: event.subject,
            faculty: event.faculty,
          ),
        );
      } else {
        emit(
          CreateTestErrorState(
            message: 'Không có câu hỏi nào trong bài kiểm tra',
          ),
        );
      }
    } catch (e) {
      emit(
        CreateTestErrorState(message: 'Không thể tải Câu hỏi của bài kiểm tra'),
      );
    }
  }

  void _onChoseCreateTest(
    ChoseCreateTestEvent event,
    Emitter<CreatetestState> emit,
  ) {
    emit(
      ChoseCreateTestState(
        subject: event.subject,
        faculty: event.faculty,
        useID: event.useId,
      ),
    );
  }

  void _onChoseCreatingNomal(
    CreatingNomalTestEvent event,
    Emitter<CreatetestState> emit,
  ) async {
    try {
      emit(CreateTestLoadingState());
      final randomQuestions = await questionRespository
          .getrandomQuesTionsByTestLevel(event.level, event.subject.maMH);

      if (randomQuestions.isEmpty || randomQuestions.length == 0) {
        emit(
          CreateTestErrorState(
            message: 'Không đủ câu hỏi cho Mức độ này: ${event.level}',
          ),
        );
        return;
      }
      String testId = FirebaseFirestore.instance.collection("test").doc().id;
      List<String> questionIds =
          randomQuestions.map((q) => q.maCauHoi).toList();
      Test newTest = Test(
        maDe: testId,
        tenDe: event.testName,
        ngayTao: DateTime.now(),
        soLuongCauHoi: randomQuestions.length,
        maNguoiDung: event.useId,
        maMon: event.subject.maMH,
        maCauHoi: questionIds,
      );
      await testRepository.createTest(newTest, testId);
      emit(
        CreatedgNomalTestState(
          questions: randomQuestions,
          test: newTest,
          subject: event.subject,
          faculty: event.faculty,
        ),
      );
    } catch (e) {
      emit(
        CreateTestErrorState(
          message: 'Lỗi khi tạo bài kiểm tra: ${e.toString()}',
        ),
      );
    }
  }

  void _onChoseCreatingWithAI(
    CreatingAITestEvent event,
    Emitter<CreatetestState> emit,
  ) async {
    try {
      emit(CreateTestLoadingState());
      final temp = QuestionGeneratorService();
      final (updatedTest, questions) = await temp.generateQuestionsFromLMStudio(
        subject: event.subject,
        testName: event.testName,
        userId: event.useId,
      );
      emit(
        CreatedgNomalTestState(
          questions: questions,
          test: updatedTest,
          subject: event.subject,
          faculty: event.faculty,
        ),
      );
    } catch (e) {
      emit(
        CreateTestErrorState(
          message: 'Lỗi khi tạo bài kiểm tra: ${e.toString()}',
        ),
      );
    }
  }
  void _onChoseCreatingWithRAG(
  CreatingRAGTestEvent event,
  Emitter<CreatetestState> emit,
) async {
  try {
    emit(CreateTestLoadingState());
    
    final (updatedTest, questions) = await ragService.generateQuestionsFromRag(
      subject: event.subject,
      testName: event.testName,
      userId: event.useId,
      difficulty: event.level, 
    );
    
    emit(
      CreatedgNomalTestState(
        questions: questions,
        test: updatedTest,
        subject: event.subject,
        faculty: event.faculty,
      ),
    );
  } catch (e) {
    emit(
      CreateTestErrorState(
        message: 'Lỗi khi tạo bài kiểm tra RAG: ${e.toString()}',
      ),
    );
  }
}
}
