import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huit_elearn/models/users.dart';
import 'package:huit_elearn/repositories/user_repository.dart';
import 'package:huit_elearn/viewModels/auth/auth_bloc.dart';
import 'package:huit_elearn/viewModels/auth/auth_state.dart';
import 'package:huit_elearn/viewModels/editprofile/profileEdit_event.dart';
import 'package:huit_elearn/viewModels/editprofile/profileEdit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final UserRepository userRepository;
  final AuthBloc authBloc;
  UserModel? currentUser;
  File? temAvatarFile;
  
  ProfileEditBloc({required this.userRepository, required this.authBloc})
    : super(ProfileInitialState()) {
    on<ProfileEditInitialEvent>(_onInitial);
    on<ProfileEditSubmitEvent>(_onSubmit);
    on<ProfileAvatarChangedEvent>(_onAvatarChanged);
    // on<ProfileAvatarSubmitEvent>(_onAvatarSubmit);
  }

  void _onInitial(
    ProfileEditInitialEvent event,
    Emitter<ProfileEditState> emit,
  ) {
    currentUser = event.user;
    emit(ProfileInitialState());
  }

  Future<void> _onSubmit(
    ProfileEditSubmitEvent event,
    Emitter<ProfileEditState> emit,
  ) async {
    if (currentUser == null) {
      emit(ProfileEditError("Không có thông tin người dùng"));
      return;
    }
    emit(ProfileEditLoadingState());
    try {
      // Cập nhật thông tin cơ bản
      UserModel updatedUser = await userRepository.updateUserProfile(
        user: currentUser!,
        newName: event.name,
        newDOB: event.dOB,
        newGender: event.gender,
      );
      
      if (temAvatarFile != null) {
        final avatarUrl = await userRepository.uploadAvatar(
          temAvatarFile!,
          currentUser!.maNguoiDung,
        );
        
        updatedUser = await userRepository.updateUserAvatar(
          user: updatedUser,
          newAvaterUrl: avatarUrl,
        );
        
        temAvatarFile = null;
      }
      
      currentUser = updatedUser;
      
      // Cập nhật thông tin ở AuthBloc để các màn hình khác nhận được
      if (authBloc.state is AuthAuthenticated) {
        authBloc.emit(AuthAuthenticated(updatedUser));
      }
      
      emit(ProfileEditSuccess(user: updatedUser));
    } catch (e) {
      emit(ProfileEditError("Cập nhật thông tin thất bại: ${e.toString()}"));
    }
  }

  void _onAvatarChanged(
    ProfileAvatarChangedEvent event,
    Emitter<ProfileEditState> emit,
  ) {
    temAvatarFile = event.avatarFile;
    emit(ProfileAvatarChangeSuccess(avatarFile: event.avatarFile));
  }

  // Future<void> _onAvatarSubmit(
  //   ProfileAvatarSubmitEvent event,
  //   Emitter<ProfileEditState> emit,
  // ) async {
  //   if (currentUser == null || temAvatarFile == null) {
  //     emit(ProfileEditError("Không có thông tin người dùng hoặc ảnh đại diện"));
  //     return;
  //   }
  //   emit(ProfileEditLoadingState());

  //   try {
  //     final avatarUrl = await userRepository.uploadAvatar(
  //       temAvatarFile!,
  //       currentUser!.maNguoiDung,
  //     );

  //     final updateUser = await userRepository.updateUserAvatar(
  //       user: currentUser!,
  //       newAvaterUrl: avatarUrl,
  //     );

  //     currentUser = updateUser;
  //     temAvatarFile = null;
      
  //     if (authBloc.state is AuthAuthenticated) {
  //       authBloc.emit(AuthAuthenticated(updateUser));
  //     }
      
  //     emit(ProfileAvatarSubmitSuccess(user: updateUser));
  //   } catch (e) {
  //     emit(ProfileEditError("Cập nhật thất bại"));
  //   }
  // }
}