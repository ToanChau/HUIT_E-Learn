import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:huit_elearn/models/users.dart';

class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();
  @override
  List<Object?> get props => [];
}

class ProfileEditInitialEvent extends ProfileEditEvent {
  final UserModel user;
  const ProfileEditInitialEvent({required this.user});
  @override
  List<Object?> get props => [user];
}

class ProfileEditSubmitEvent extends ProfileEditEvent {
  final String name;
  final DateTime dOB;
  final String gender;
  const ProfileEditSubmitEvent({
    required this.name,
    required this.dOB,
    required this.gender,
  });

  @override
  List<Object?> get props => [name,dOB,gender];
}

class ProfileAvatarChangedEvent extends ProfileEditEvent {
  final File avatarFile;
  const ProfileAvatarChangedEvent({
    required this.avatarFile,
  });
  @override
  List<Object?> get props => [avatarFile];
}
class ProfileAvatarSubmitEvent extends ProfileEditEvent {
  const ProfileAvatarSubmitEvent();
}