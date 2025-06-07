import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huit_elearn/models/faculty.dart';

class FacultyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Faculty>> getAllFaculties() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("faculties").get();

      return querySnapshot.docs.map((doc) {
        List<String> dsGiangVien = [];
        if (doc['DSGiangVien'] != null) {
          dsGiangVien = List<String>.from(doc['DSGiangVien']);
        }
        return Faculty(
          maKhoa: doc["MaKhoa"],
          tenKhoa: doc['TenKhoa'] ?? "",
          dSGiangVien: dsGiangVien,
          anhKhoa: doc['AnhKhoa'] ?? "",
          gioiThieu: doc['GioiThieu'] ?? "",
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
  
}
