// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:huit_elearn/models/users.dart';

class ProfileEditState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileEditState {}

class ProfileEditLoadingState extends ProfileEditState {}

class ProfileEditSuccess extends ProfileEditState {
  final UserModel user;
  ProfileEditSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

class ProfileAvatarChangeSuccess extends ProfileEditState {
  final File avatarFile;
  ProfileAvatarChangeSuccess({required this.avatarFile});
  @override
  List<Object?> get props => [avatarFile];
}

class ProfileAvatarSubmitSuccess extends ProfileEditState {
  final UserModel user;

  ProfileAvatarSubmitSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileEditError extends ProfileEditState {
  final String message;
  
  ProfileEditError(this.message);
  
  @override
  List<Object> get props => [message];
}