
import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UploadState extends Equatable {}

class UploadInitialState extends UploadState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UploadLoadingState extends UploadState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UploadFileSuccessState extends UploadState {
  final String downloadURL;
  final String maTaiLieu;
  final File file;
  final int kichThuoc;
  final String tenTaiLieu;
  UploadFileSuccessState({
    required this.downloadURL,
    required this.maTaiLieu,
    required this.file,
    required this.kichThuoc,
    required this.tenTaiLieu,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
    downloadURL,
    maTaiLieu,
    file,
    kichThuoc,
    tenTaiLieu,
  ];
}

class UploadDetailSuccessState extends UploadState {
  @override
  List<Object?> get props => [];
}

class UploadFailState extends UploadState {
  final String error;
  UploadFailState({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class UploadCancelledState extends UploadState {
  final String? message;
  
  UploadCancelledState({this.message});

  @override
  List<Object?> get props => [message];
}

class UploadProgressState extends UploadState {
  final double progress;
  final String filename;
  final String remainingTime;
  UploadProgressState({
    required this.progress,
    required this.filename,
    required this.remainingTime,
  });
  @override
  List<Object?> get props => [progress, filename, remainingTime];
}
