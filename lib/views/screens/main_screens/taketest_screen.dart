import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:huit_elearn/models/faculty.dart';
import 'package:huit_elearn/models/subjects.dart';
import 'package:huit_elearn/models/tests.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_bloc.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_event.dart';
import 'package:huit_elearn/viewModels/createtest/createtest_state.dart';
import 'package:huit_elearn/viewModels/taketest/taketest_bloc.dart';
import 'package:huit_elearn/viewModels/taketest/taketest_event.dart';
import 'package:huit_elearn/viewModels/taketest/taketest_state.dart';
import 'package:huit_elearn/views/screens/main_view.dart';

class TaketestScreen extends StatefulWidget {
  final List<Question>? questions;
  final Test? test;
  final Subject? subject;
  final Faculty? faculty;

  const TaketestScreen({
    super.key,
    this.questions,
    this.test,
    this.subject,
    this.faculty,
  });

  @override
  State<TaketestScreen> createState() => _TaketestScreenState();
}

class _TaketestScreenState extends State<TaketestScreen> {
  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_) {
    MainView.hideNav.value = true;
  });
    _initializeData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    MainView.hideNav.value = false;
  });
    super.dispose();
  }

  void _initializeData() {
    if (widget.test != null &&
        widget.subject != null &&
        widget.questions != null) {
      context.read<TaketestBloc>().add(
        LoadQuestionsEvent(
          faculty: widget.faculty!,
          questions: widget.questions!,
          test: widget.test!,
          subject: widget.subject!,
        ),
      );
    } else {
      final state = context.read<CreatetestBloc>().state;
      if (state is ChoseTestState) {
        context.read<TaketestBloc>().add(
          LoadQuestionsEvent(
            faculty: state.faculty,
            questions: state.questions,
            test: state.test,
            subject: state.subject,
          ),
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      return const Scaffold(
        body: Center(child: Text("Vui lòng đăng nhập để làm bài kiểm tra")),
      );
    }
    final userID = authState.user.maNguoiDung;

    return BlocBuilder<TaketestBloc, TaketestState>(
      builder: (context, state) {
        if (state is TaketestInitialState || state is TaketestLoadingState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is TaketestLoadedState) {
          final currentQuestion = state.questions[state.currentIndex];
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  context.read<CreatetestBloc>().add(
                    ChoseSubjectEvent(
                      subject: state.subject,
                      userID: userID,
                      faculty: state.faculty,
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 100), () {
                    context.pop();
                  });
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Đề ${state.test.tenDe}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Câu ${state.currentIndex + 1}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      currentQuestion.noiDungCauHoi,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    ...currentQuestion.cauTraLoi.map((answer) {
                      Color answerColor = Colors.white;
                      if (state.selectedAnswer != null) {
                        if (answer.noiDung == state.selectedAnswer) {
                          answerColor =
                              state.isCurrentAnswerCorrect!
                                  ? Colors.green.shade100
                                  : Color.fromRGBO(238, 116, 10, 0.466);
                        } else if (answer.isCorrect) {
                          answerColor = Colors.green.shade100;
                        }
                      }
                      return _buildAnswerOption(
                        answer.noiDung,
                        answer.isCorrect,
                        answerColor,
                        state.selectedAnswer == null,
                        context,
                      );
                    }),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed:
                          state.selectedAnswer != null
                              ? () => context.read<TaketestBloc>().add(
                                NextQuestionEvent(),
                              )
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 44, 62, 80),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        state.currentIndex < state.questions.length - 1
                            ? 'Tiếp tục'
                            : 'Hoàn thành',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        } else if (state is TaketestCompletedState) {
          return _buildResultScreen(state, context, userID);
        } else if (state is TaketestErrorState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: true,
            ),
            body: Center(
              child: Text(
                'Đã xảy ra lỗi: ${state.errorMessage}',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: Text("Đang tải...")));
      },
    );
  }

  Widget _buildAnswerOption(
    String text,
    bool correct,
    Color color,
    bool canSelect,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap:
          canSelect
              ? () => context.read<TaketestBloc>().add(
                AnswerQuestionEvent(answer: text, isCorrect: correct),
              )
              : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(
    TaketestCompletedState state,
    BuildContext context,
    String userID,
  ) {
    final percentage = (state.score / state.totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            context.read<CreatetestBloc>().add(
              ChoseSubjectEvent(
                subject: state.subject,
                userID: userID,
                faculty: state.faculty,
              ),
            );
            Future.delayed(const Duration(milliseconds: 100), () {
              context.pop();
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Kết quả bài kiểm tra'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Điểm của bạn',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            percentage >= 70
                                ? Colors.green.shade100
                                : percentage >= 50
                                ? Colors.orange.shade100
                                : Colors.red.shade100,
                        border: Border.all(
                          color:
                              percentage >= 70
                                  ? Colors.green
                                  : percentage >= 50
                                  ? Colors.orange
                                  : Colors.red,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color:
                                percentage >= 70
                                    ? Colors.green
                                    : percentage >= 50
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${state.score}/${state.totalQuestions} câu đúng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      percentage >= 70
                          ? 'Xuất sắc!'
                          : percentage >= 50
                          ? 'Khá tốt!'
                          : 'Cần cố gắng thêm!',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  context.read<CreatetestBloc>().add(
                    ChoseSubjectEvent(
                      subject: state.subject,
                      userID: userID,
                      faculty: state.faculty,
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 100), () {
                    context.pop();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 44, 62, 80),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Trở về',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ExpansionTile(
                title: Text(
                  'Xem lại các câu trả lời',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.questions.length,
                    itemBuilder: (context, index) {
                      final question = state.questions[index];
                      final userAnswer = state.userAnswers[index];
                      final isCorrect = state.correctAnswers[index];

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Câu ${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    isCorrect ?? false
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color:
                                        isCorrect ?? false
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.noiDungCauHoi,
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Câu trả lời của bạn:',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                userAnswer ?? 'Không trả lời',
                                style: TextStyle(
                                  color:
                                      isCorrect ?? false
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                              if (!(isCorrect ?? false)) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Đáp án đúng:',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  question.cauTraLoi
                                      .firstWhere((answer) => answer.isCorrect)
                                      .noiDung,
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
