import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huit_elearn/models/subjects.dart';
import 'package:huit_elearn/models/tests.dart';
import 'package:huit_elearn/repositories/question_respository.dart';
import 'package:huit_elearn/repositories/test_repository.dart';
import 'package:http/http.dart' as http;

class QuestionGeneratorService {
  final QuestionRespository questionRepo = QuestionRespository();
  final TestRepository testRepo = TestRepository();

  Future<(Test, List<Question>)> generateQuestionsFromLMStudio({
    required Subject subject,
    required String testName,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.2.8:5555/v1/chat/completions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "model": "local-model",
          "messages": [
            {
              "role": "user",
              "content": _buildPrompt(subject.tenMH, subject.maMH),
            },
          ],
          "temperature": 0.8,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception("Lỗi khi gọi LM Studio: ${response.body}");
      }

      final content =
          jsonDecode(response.body)["choices"][0]["message"]["content"];
      final jsonData = jsonDecode(content);
      final List<Question> questions = [];

      for (var q in jsonData['questions']) {
        final List<Answer> answers =
            (q['cauTraLoi'] as List).map((a) {
              return Answer(noiDung: a['noiDung'], isCorrect: a['isCorrect']);
            }).toList();

        questions.add(
          Question(
            maCauHoi:
                DateTime.now().millisecondsSinceEpoch.toString() +
                answers.first.noiDung.hashCode.toString(),
            noiDungCauHoi: q['noiDungCauHoi'],
            phanLoai: q['phanLoai'],
            maMH: subject.maMH,
            cauTraLoi: answers,
          ),
        );
      }

      List<String> questionIds = [];
      for (var question in questions) {
        final docRef = await FirebaseFirestore.instance
            .collection("questions")
            .add({
              "NoiDungCauHoi": question.noiDungCauHoi,
              "PhanLoai": question.phanLoai,
              "MaMH": question.maMH,
              "CauTraLoi":
                  question.cauTraLoi
                      .map(
                        (a) => {"NoiDung": a.noiDung, "IsCorrect": a.isCorrect},
                      )
                      .toList(),
            });
        questionIds.add(docRef.id);
      }

      final test = Test(
        maDe: '',
        tenDe: testName,
        ngayTao: DateTime.now(),
        soLuongCauHoi: questions.length,
        maNguoiDung: userId,
        maMon: subject.maMH,
        maCauHoi: questionIds,
      );

      final testId = await testRepo.createTest(test);
      final updatedTest = test.copyWith(maDe: testId);

      return (updatedTest, questions);
    } catch (e) {
      throw Exception("Đã xảy ra lỗi : $e");
    }
  }

  String _buildPrompt(String subjectName, String maMH) {
    return '''
Tạo 3 câu hỏi trắc nghiệm cho môn học "$subjectName".
Mỗi câu hỏi phải có 4 đáp án (A, B, C, D), trong đó chỉ có một đáp án đúng.
Định dạng trả về phải là JSON với cấu trúc như sau:
{
  "questions": [
    {
      "noiDungCauHoi": "Nội dung câu hỏi 1",
      "phanLoai": "Dễ",
      "maMH": "$maMH",
      "cauTraLoi": [
        {"noiDung": "Đáp án A", "isCorrect": false},
        {"noiDung": "Đáp án B", "isCorrect": true},
        {"noiDung": "Đáp án C", "isCorrect": false},
        {"noiDung": "Đáp án D", "isCorrect": false}
      ]
    }
  ]
}
noiDung chỉ chứa nội dung của câu trả lời. Chỉ trả về JSON thuần túy, không thêm dấu backticks, không đánh dấu code block, không thêm bất kỳ văn bản nào trước hoặc sau.
''';
  }
}

extension TestExtension on Test {
  Test copyWith({String? maDe}) {
    return Test(
      maDe: maDe ?? this.maDe,
      tenDe: this.tenDe,
      ngayTao: this.ngayTao,
      soLuongCauHoi: this.soLuongCauHoi,
      maNguoiDung: this.maNguoiDung,
      maMon: this.maMon,
      maCauHoi: this.maCauHoi,
    );
  }
}
