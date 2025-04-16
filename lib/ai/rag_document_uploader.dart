import 'package:huit_elearn/ai/rag_service.dart';
import 'package:huit_elearn/models/documents.dart';

class RagDocumentProcessor {
  final RagService _ragService = RagService();

  /// Xử lý tài liệu sau khi đã upload thành công và lưu thông tin vào Firestore
  Future<bool> processUploadedDocument(Document document) async {
    try {
      final storagePath = _getStoragePathFromUrl(document.uRL);
      
      // Gửi tài liệu đến RAG service để xử lý và tạo embeddings
      final success = await _ragService.processDocument(
        documentPath: storagePath,
        subjectId: document.maMH,
      );
      
      return success;
    } catch (e) {
      print('Lỗi khi xử lý tài liệu RAG: $e');
      // Trả về false nhưng không throw exception để không ảnh hưởng đến luồng upload
      return false;
    }
  }
  
  /// Trích xuất đường dẫn Storage từ URL tải xuống
  String _getStoragePathFromUrl(String downloadUrl) {
    
    final uri = Uri.parse(downloadUrl);
    final pathSegment = uri.pathSegments.lastWhere((element) => element.isNotEmpty, orElse: () => '');
    
    if (pathSegment.isEmpty) {
      final path = downloadUrl.split('/o/').last.split('?').first;
      return Uri.decodeComponent(path);
    }
    
    return Uri.decodeComponent(pathSegment);
  }
  
}