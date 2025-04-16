import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huit_elearn/models/lecturer.dart';

class LecturerRespository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Lecturer>> getListLecturerByListId(List<String>? listID) async {
  try {
    if (listID == null || listID.isEmpty) {
      print("Danh sách ID giảng viên trống hoặc null");
      return [];
    }
    
    print("Đang tải ${listID.length} giảng viên với ID: $listID");
    
    QuerySnapshot querySnapshot = await _firestore
        .collection('lecturers')
        .where("MaGV", whereIn: listID)
        .get();
    
    final results = querySnapshot.docs
        .map((doc) => Lecturer.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    
    print("Đã tải được ${results.length} giảng viên");
    return results;
  } catch (e) {
    print('Lỗi khi lấy danh sách giảng viên theo ID: $e');
    return [];
  }
}
}
