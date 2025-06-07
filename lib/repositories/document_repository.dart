import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:huit_elearn/models/documents.dart';
import 'dart:io';

import 'package:huit_elearn/models/subjects.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

typedef ProgressCallback =
    void Function(double progress, double remainingSeconds);

class DocumentRepository {
  final FirebaseStorage _store = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UploadTask? _currentUploadTask;

  Future<String?> uploadFileWithProgress(
    File file,
    String fileName,
    ProgressCallback onProgress,
  ) async {
    try {
      final storageRef = _store.ref().child('Document/$fileName');

      DateTime startTime = DateTime.now();
      _currentUploadTask = storageRef.putFile(file);
      _currentUploadTask!.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (snapshot.state == TaskState.running) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;

          final elapsedTime =
              DateTime.now().difference(startTime).inMilliseconds / 10000;
          final bytesPerSecond = snapshot.bytesTransferred / elapsedTime;
          final remainingBytes =
              snapshot.totalBytes - snapshot.bytesTransferred;
          final remainingSeconds =
              bytesPerSecond > 0 ? remainingBytes / bytesPerSecond : 0;

          onProgress(progress.toDouble(), remainingSeconds.toDouble());
        }
      });

      final snapshot = await _currentUploadTask!.whenComplete(() => null);

      if (_currentUploadTask != null) {
        final downloadUrl = await snapshot.ref.getDownloadURL();
        _currentUploadTask = null;
        return downloadUrl;
      } else {
        return null;
      }
    } catch (e) {
      _currentUploadTask = null;
      throw Exception('Tải lên thất bại: $e');
    }
  }

  Future<void> cancelUpload({String? url}) async {
    if (_currentUploadTask != null) {
      await _currentUploadTask?.cancel();
      _currentUploadTask = null;
    }
    if (url != null) {
      try {
        final Reference fileRef = _store.refFromURL(url);
        await fileRef.delete();
      } catch (e) {
        throw Exception('Failed to delete file from Firebase Storage: $e');
      }
    }
  }

  Future<void> saveDocumentDetails(Document document) async {
    try {
      await _firestore.collection('documents').doc(document.maTaiLieu).set({
        'maTaiLieu': document.maTaiLieu,
        'tenTaiLieu': document.tenTaiLieu,
        'ngayDang': document.ngayDang,
        'nguoiDang': document.nguoiDang,
        'moTa': document.moTa,
        'kichThuoc': document.kichThuoc,
        'loai': document.loai,
        'trangThai': document.trangThai,
        'luotTaiVe': document.luotTaiVe ?? 0,
        'luotThich': document.luotThich ?? 0,
        'maMH': document.maMH,
        'uRL': document.uRL,
        'previewImages': document.previewImages,
      });
    } catch (e) {
      throw Exception('Failed to save document details: $e');
    }
  }

  Future<int> getFileSize(File file) async {
    try {
      final fileLength = await file.length();
      return fileLength;
    } catch (e) {
      throw Exception('Failed to get file size: $e');
    }
  }

  Future<List<Document>> getListDocumentByMaMH(Subject subject) async {
    QuerySnapshot querySnapshot =
        await _firestore
            .collection("documents")
            .where("maMH", isEqualTo: subject.maMH)
            .where("trangThai")
            .get();
    return querySnapshot.docs.map((doc) {
      return Document(
        maTaiLieu: doc.id,
        tenTaiLieu: doc["tenTaiLieu"],
        ngayDang: (doc["ngayDang"] as Timestamp).toDate(),
        nguoiDang: doc["nguoiDang"],
        moTa: doc["moTa"],
        kichThuoc: doc["kichThuoc"],
        loai: doc["loai"],
        trangThai: doc["trangThai"],
        maMH: doc["maMH"],
        uRL: doc["uRL"],
        luotTaiVe: doc["luotTaiVe"],
        luotThich: doc["luotThich"],
        previewImages:
            doc["previewImages"] != null
                ? List<String>.from(doc["previewImages"])
                : null,
      );
    }).toList();
  }

  Future<List<Document>> getAcceptedDocument(String nguoiDang) async {
    QuerySnapshot querySnapshot =
        await _firestore
            .collection('documents')
            .where("nguoiDang", isEqualTo: nguoiDang)
            .where("trangThai", isEqualTo: "Đã duyệt")
            .get();
    return querySnapshot.docs.map((doc) {
      return Document(
        maTaiLieu: doc.id,
        tenTaiLieu: doc["tenTaiLieu"],
        ngayDang: (doc["ngayDang"] as Timestamp).toDate(),
        nguoiDang: doc["nguoiDang"],
        moTa: "",
        kichThuoc: doc["kichThuoc"],
        loai: doc["loai"],
        trangThai: doc["trangThai"],
        maMH: doc["maMH"],
        uRL: doc["uRL"],
        luotTaiVe: doc["luotTaiVe"],
        luotThich: doc["luotThich"],
        previewImages:
            doc["previewImages"] != null
                ? List<String>.from(doc["previewImages"])
                : null,
      );
    }).toList();
  }

  Future<List<Document>> getUnAcceptedDocument(String nguoiDang) async {
    QuerySnapshot querySnapshot =
        await _firestore
            .collection('documents')
            .where("nguoiDang", isEqualTo: nguoiDang)
            .where("trangThai", isEqualTo: "Chờ duyệt")
            .get();
    return querySnapshot.docs.map((doc) {
      return Document(
        maTaiLieu: doc.id,
        tenTaiLieu: doc["tenTaiLieu"],
        ngayDang: (doc["ngayDang"] as Timestamp).toDate(),
        nguoiDang: doc["nguoiDang"],
        moTa: "",
        kichThuoc: doc["kichThuoc"],
        loai: doc["loai"],
        trangThai: doc["trangThai"],
        maMH: doc["maMH"],
        uRL: doc["uRL"],
        luotTaiVe: doc["luotTaiVe"],
        luotThich: doc["luotThich"],
        previewImages:
            doc["previewImages"] != null
                ? List<String>.from(doc["previewImages"])
                : null,
      );
    }).toList();
  }

  Future<List<Document>> getListDocmentAllQuery() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('documents').get();
    return querySnapshot.docs.map((doc) {
      return Document(
        maTaiLieu: doc.id,
        tenTaiLieu: doc["tenTaiLieu"],
        ngayDang: (doc["ngayDang"] as Timestamp).toDate(),
        nguoiDang: doc["nguoiDang"],
        moTa: "moTa",
        kichThuoc: doc["kichThuoc"],
        loai: doc["loai"],
        trangThai: doc["trangThai"],
        maMH: doc["maMH"],
        uRL: doc["uRL"],
        luotTaiVe: doc["luotTaiVe"],
        luotThich: doc["luotThich"],
        previewImages:
            doc["previewImages"] != null
                ? List<String>.from(doc["previewImages"])
                : null,
      );
    }).toList();
  }

  String generateDocumentId() {
    return _firestore.collection('documents').doc().id;
  }

  Future<bool> downloadDocument(
    Document document,
    ProgressCallback onProgress,
  ) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Chưa được cấp quyền lưu trữ');
      }

      final dio = Dio();

      final appDocDir = await getApplicationDocumentsDirectory();

      final fileName = document.tenTaiLieu.replaceAll(' ', '_');
      final fileExtension = _getFileExtension(document.uRL);
      final savePath = '${appDocDir.path}/$fileName$fileExtension';

      DateTime startTime = DateTime.now();
      await dio.download(
        document.uRL,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;

            final elapsedTime =
                DateTime.now().difference(startTime).inMilliseconds / 1000;
            final bytesPerSecond = received / elapsedTime;
            final remainingBytes = total - received;
            final remainingSeconds =
                bytesPerSecond > 0 ? remainingBytes / bytesPerSecond : 0;

            onProgress(progress.toDouble(), remainingSeconds.toDouble());
          }
        },
      );

      await _firestore.collection('documents').doc(document.maTaiLieu).update({
        'luotTaiVe': FieldValue.increment(1),
      });
      await OpenFile.open(savePath);

      return true;
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  String _getFileExtension(String url) {
    final uri = Uri.parse(url);
    final path = uri.path;
    final lastDotIndex = path.lastIndexOf('.');
    if (lastDotIndex != -1) {
      return path.substring(lastDotIndex);
    }
    return '';
  }

  Future<void> voteDocument(String documentid) async {
    try {
      await _firestore.collection("documents").doc(documentid).update({
        'luotThich': FieldValue.increment(1),
      });
    } catch (e) {
      throw (e);
    }
  }
}
