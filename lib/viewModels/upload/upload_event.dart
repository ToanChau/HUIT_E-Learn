// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class UploadInitial extends UploadEvent {}

class UploadStarted extends UploadEvent {
  final File file;
  final String FileName;
  UploadStarted({required this.file, required this.FileName});

  @override
  // TODO: implement props
  List<Object?> get props => [file, FileName];
}

class UploadDetailSubmitted extends UploadEvent {
  final String tenTaiLieu;
  final String moTa;
  final String maMH;
  
  UploadDetailSubmitted({
    required this.tenTaiLieu,
    required this.moTa,
    required this.maMH,
  });
  
  @override
  List<Object?> get props => [tenTaiLieu, moTa, maMH];
}
class UploadCancelled extends UploadEvent {
  final bool isManualCancel;
  
  UploadCancelled({this.isManualCancel = true});

  @override
  List<Object?> get props => [isManualCancel];
}

