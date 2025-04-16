import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huit_elearn/models/subjects.dart';

class SubjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Subject>> getSubjectsByFaculty(String maKhoa) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('subjects')
          .where('MaKhoa', isEqualTo: maKhoa)
          .get();
      
      return querySnapshot.docs.map((doc) {
        return Subject(
          maMH: doc['MaMH']??'',
          tenMH: doc['TenMH'] ?? '',
          maKhoa: doc['MaKhoa'] ?? '',
          anhMon: doc['AnhMon'] ?? '',
          gioiThieu: doc['GioiThieu'] ?? '',
          chuongTrinhDT: doc['ChuongTrinhDaoTao'] ?? ''
        );
      }).toList();
    } catch (e) {
      print('Error fetching subjects: $e');
      return [];
    }
  }
  
}