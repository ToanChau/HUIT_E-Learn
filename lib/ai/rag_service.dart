import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:huit_elearn/ai/question_generator.dart';
import 'package:huit_elearn/models/subjects.dart';
import 'package:huit_elearn/models/tests.dart';
import 'package:huit_elearn/repositories/test_repository.dart';

class RagService {
  final String _baseUrl = 'http://local:5000';

  Future<bool> processDocument({
    required String documentPath,
    required String subjectId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/process_document'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'document_path': documentPath,
          'subject_id': subjectId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Lỗi khi xử lý tài liệu: ${response.body}');
      }

      final result = jsonDecode(response.body);
      return result['success'] ?? false;
    } catch (e) {
      throw Exception('Đã xảy ra lỗi: $e');
    }
  }

  /// Tạo câu hỏi cho bài kiểm tra dựa trên tài liệu đã được xử lý
  Future<(Test, List<Question>)> generateQuestionsFromRag({
    required Subject subject,
    required String testName,
    required String userId,
    required String difficulty,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/generate_questions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'subject_id': subject.maMH,
          'subject_name': subject.tenMH,
          'difficulty': difficulty,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Lỗi khi tạo câu hỏi: ${response.body}');
      }

      final result = jsonDecode(response.body);
      var content = result['result'];

      if (content.trim().startsWith('```json')) {
        content = content.replaceFirst('```json', '').trim();
      }
      if (content.trim().endsWith('```')) {
        content = content.substring(0, content.length - 3).trim();
      }
      // tạo câu hỏi giống bên kia
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

      // Tạo test và lưu vào Firebase giống bên kia
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

      final testRepository = TestRepository();
      final testId = await testRepository.createTest(test);
      final updatedTest = test.copyWith(maDe: testId);

      return (updatedTest, questions);
    } catch (e) {
      throw Exception("Đã xảy ra lỗi: $e");
    }
  }
}
