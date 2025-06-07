import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huit_elearn/models/report.dart';

class ReportRepository {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    
    Future<void> sendReport(Report report) async {
    try {
      await _firestore.collection('reports').doc(report.MaBaoCao).set(report.toJson());
    } catch (e) {
      throw Exception('Không thể gửi báo cáo: $e');
    }
  }
}