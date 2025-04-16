import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huit_elearn/models/tests.dart';

class TestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Test>> getAllTestByUserIDandMaMon(
    String useID,
    String maMon,
  ) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection("test")
              .where("MaNguoiDung", isEqualTo: useID)
              .where("MaMon", isEqualTo: maMon)
              .get();
      return querySnapshot.docs.map((doc) {
        return Test(
          maDe: doc.id,
          tenDe: doc["TenDe"],
          ngayTao: (doc["NgayTao"] as Timestamp).toDate(),
          soLuongCauHoi: doc["SoLuongCauHoi"],
          maNguoiDung: doc["MaNguoiDung"],
          maMon: doc["MaMon"],
          maCauHoi: List<String>.from(doc["MaCauHoi"]),
        );
      }).toList();
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }
Future<String> createTest(Test test, [String? customId]) async {
  try {
    String docId = customId ?? _firestore.collection("test").doc().id;
    
    await _firestore.collection("test").doc(docId).set({
      "MaDe": docId,
      "TenDe": test.tenDe,
      "NgayTao": Timestamp.fromDate(test.ngayTao),
      "SoLuongCauHoi": test.soLuongCauHoi,
      "MaNguoiDung": test.maNguoiDung,
      "MaMon": test.maMon,
      "MaCauHoi": test.maCauHoi,
    });
    return docId;
  } catch (e) {
    print("Error creating test: $e");
    throw e;
  }
}
}
