import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huit_elearn/repositories/user_repository.dart';
import 'package:huit_elearn/viewModels/changepass/changepass_event.dart';
import 'package:huit_elearn/viewModels/changepass/changepass_state.dart';

class ChangepassBloc extends Bloc<ChangepassEvent, ChangepassState> {
  final UserRepository _userRepository = UserRepository();

  ChangepassBloc() : super(ChangepassInitialState()) {
    on<ChangepassInitialEvent>((event, emit) {
      emit(ChangepassInitialState());
    });

    on<ChangingpassEvent>((event, emit) async {
      emit(ChangingPassState());
      
      try {
        if (event.newPass.isEmpty || event.currentPass.isEmpty || event.confirmPass.isEmpty) {
          emit(ChangePassErrorState(error: "Vui lòng điền đầy đủ thông tin"));
          return;
        }

        if (event.newPass != event.confirmPass) {
          emit(ChangePassErrorState(error: "Mật khẩu mới không khớp với xác nhận mật khẩu"));
          return;
        }
        
        await _userRepository.changePassword(
          currentPassword: event.currentPass,
          newPassword: event.newPass,
        );
        
        emit(ChangePassCompleteState());
      } catch (e) {
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'wrong-password':
              emit(ChangePassErrorState(error: "Mật khẩu hiện tại không đúng"));
              break;
            case 'weak-password':
              emit(ChangePassErrorState(error: "Mật khẩu mới quá yếu, vui lòng chọn mật khẩu mạnh hơn"));
              break;
            case 'requires-recent-login':
              emit(ChangePassErrorState(error: "Cần đăng nhập lại để thực hiện thao tác này"));
              break;
            default:
              emit(ChangePassErrorState(error: "Lỗi xác thực: ${e.message}"));
          }
        } else {
          emit(ChangePassErrorState(error: "Đã xảy ra lỗi: ${e.toString()}"));
        }
      }
    });
  }
}