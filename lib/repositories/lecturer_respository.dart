import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huit_elearn/models/lecturer.dart';

class LecturerRespository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Lecturer>> getListLecturerByListId(List<String>? listID) async {
  try {
    if (listID == null || listID.isEmpty) {
      return [];
    }
    
    
    QuerySnapshot querySnapshot = await _firestore
        .collection('lecturers')
        .where("MaGV", whereIn: listID)
        .get();
    
    final results = querySnapshot.docs
        .map((doc) => Lecturer.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return results;
  } catch (e) {
    return [];
  }
}
}
