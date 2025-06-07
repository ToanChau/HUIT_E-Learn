import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:huit_elearn/models/users.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserModel?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<UserModel> updateUserProfile({
    required UserModel user,
    String? newName,
    DateTime? newDOB,
    String? newGender,
  }) async {
    UserModel updateUser = user.copyWith(
      tenNguoiDung: newName ?? user.tenNguoiDung,
      ngaySinh: newDOB ?? user.ngaySinh,
      gioiTinh: newGender ?? user.gioiTinh,
    );

    await _firestore
        .collection('users')
        .doc(user.maNguoiDung)
        .update(updateUser.toMap());

    return updateUser;
  }

  Future<String> uploadAvatar(File avatarFile, String userId) async {
    Reference storageRef = _storage.ref().child('AnhNguoiDung/$userId.jpg');

    UploadTask uploadTask = storageRef.putFile(avatarFile);
    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<UserModel> updateUserAvatar({
    required UserModel user,
    required String newAvaterUrl,
  }) async {
    UserModel updateUser = user.copyWith(anhDaiDien: newAvaterUrl);

    await _firestore.collection('users').doc(user.maNguoiDung).update({
      'anhDaiDien': newAvaterUrl,
    });

    return updateUser;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("Không tìm thấy người dùng đăng nhập");
    }

    if (user.email == null) {
      throw Exception("Người dùng không có email");
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);

    await _firestore.collection('users').doc(user.uid).update({
      'matKhau': newPassword,
    });
  }
}
