import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/viewModels/auth/auth_event.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: event.user.eMail,
              password: event.password,
            );
        UserModel newUser = UserModel(
          maNguoiDung: userCredential.user!.uid,
          eMail: userCredential.user?.email ?? "",
          sDT: userCredential.user?.phoneNumber ?? event.user.sDT,
          tenNguoiDung: userCredential.user?.displayName ?? userCredential.user!.uid,
          anhDaiDien: userCredential.user?.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/huit-e-learn.firebasestorage.app/o/AnhNguoiDung%2Fnguoidung4.jpg?alt=media&token=850489cf-2e01-4312-a74e-1cf8c85c2bad",
          gioiTinh:  'Nam',
          matKhau: event.password,
          ngaySinh: DateTime.now()
        );

        await _firestore
            .collection('users')
            .doc(newUser.maNguoiDung)
            .set(newUser.toMap());

        emit(AuthAuthenticated(newUser));
      } catch (e) {
        emit(AuthError("Đăng nhập thất bại: ${e.toString()}"));
      }
    });
    on<AuthCheckLogin>((event, emit) async {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          UserModel userModel = UserModel.fromMap(
            userDoc.data() as Map<String, dynamic>,
          );
          emit(AuthAuthenticated(userModel));
        }
      }
    });
    on<AuthSignOut>((event, emit) async {
      await _auth.signOut();
      emit(AuthInitial());
    });
    on<AuthSignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        DocumentSnapshot userDoc =
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .get();

        if (userDoc.exists) {
          UserModel userModel = UserModel.fromMap(
            userDoc.data() as Map<String, dynamic>,
          );
          emit(AuthAuthenticated(userModel));
        } else {
          emit(AuthError("Không tìm thấy thông tin người dùng!"));
        }
      } catch (e) {
        emit(AuthError("Đăng nhập thất bại: ${e.toString()}"));
      }
    });
  }
}
