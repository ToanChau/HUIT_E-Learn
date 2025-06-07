import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huit_elearn/models/tests.dart';

class QuestionRespository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Question>> GetQuestionsByIds(List<String> questionsIds) async {
    try {
      List<Future<DocumentSnapshot>> futures =
          questionsIds.map((id) {
            return _firestore.collection("questions").doc(id).get();
          }).toList();

      List<DocumentSnapshot> snapshots = await Future.wait(futures);

      return await _buildQuestionsFromDocs(snapshots);
    } catch (e) {
      return [];
    }
  }

  Future<List<Question>> getQuestionsByTestId(String testId) async {
    try {
      DocumentSnapshot testDoc =
          await _firestore.collection("test").doc(testId).get();
      if (testDoc.exists) {
        List<String> maCauHois = List<String>.from(testDoc["MaCauHoi"]);
        return GetQuestionsByIds(maCauHois);
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<List<Question>> getrandomQuestionbyLevel(
   final String level,
   final int soLuong,
   final String MaMH,
  ) async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection("questions")
              .where("PhanLoai", isEqualTo: level)
              .where("MaMH", isEqualTo: MaMH)
              .get();

      List<DocumentSnapshot> allDocs = snapshot.docs;

      if (soLuong >= allDocs.length) {
        return await _buildQuestionsFromDocs(allDocs);
      }

      allDocs.shuffle();
      List<DocumentSnapshot> selectedDocs = allDocs.take(soLuong).toList();

      return await _buildQuestionsFromDocs(selectedDocs);
    } catch (e) {
      return [];
    }
  }

  Future<List<Question>> getrandomQuesTionsByTestLevel(
    String Level,
    String MaMH,
  ) async {
    try {
      List<Question> ListQuestion = [];
      int deRequired = 0, trungBinhRequired = 0, khoRequired = 0;
      int totalRequired = 0;

      if (Level == "Dễ") {
        deRequired = 10;
        trungBinhRequired = 7;
        khoRequired = 3;
      } else if (Level == "Khó") {
        deRequired = 25;
        trungBinhRequired = 15;
        khoRequired = 10;
      } else {
        deRequired = 25;
        trungBinhRequired = 10;
        khoRequired = 5;
      }

      totalRequired = deRequired + trungBinhRequired + khoRequired;

      List<Question> deQuestions = await getrandomQuestionbyLevel(
        "Dễ",
        deRequired,
        MaMH,
      );
      List<Question> trungBinhQuestions = await getrandomQuestionbyLevel(
        "Trung bình",
        trungBinhRequired,
        MaMH,
      );
      List<Question> khoQuestions = await getrandomQuestionbyLevel(
        "Khó",
        khoRequired,
        MaMH,
      );

      ListQuestion.addAll(deQuestions);
      ListQuestion.addAll(trungBinhQuestions);
      ListQuestion.addAll(khoQuestions);

      if (ListQuestion.length < totalRequired) {
        print(
          "Warning: Not enough questions available. Required: $totalRequired, Available: ${ListQuestion.length}",
        );
        print("Dễ: Required: $deRequired, Available: ${deQuestions.length}");
        print(
          "Trung bình: Required: $trungBinhRequired, Available: ${trungBinhQuestions.length}",
        );
        print("Khó: Required: $khoRequired, Available: ${khoQuestions.length}");

       
      }

      return ListQuestion;
    } catch (e) {
      print("Error getting random questions: $e");
      return [];
    }
  }

  Future<List<Question>> _buildQuestionsFromDocs(
    final List<DocumentSnapshot> docs,
  ) async {
    List<Question> questions = [];

    for (var doc in docs) {
      if (doc.exists) {
        List<dynamic> answerData = doc["CauTraLoi"];
        List<Answer> answers =
            answerData.map((data) {
              return Answer(
                noiDung: data["NoiDung"],
                isCorrect: data["IsCorrect"],
              );
            }).toList();

        questions.add(
          Question(
            maCauHoi: doc.id,
            maMH: doc["MaMH"],
            noiDungCauHoi: doc["NoiDungCauHoi"],
            phanLoai: doc["PhanLoai"],
            cauTraLoi: answers,
          ),
        );
      }
    }

    return questions;
  }
}
