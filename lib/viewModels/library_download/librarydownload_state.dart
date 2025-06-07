import 'package:equatable/equatable.dart';

class LibrarydownloadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LibrarydownloadInitialState extends LibrarydownloadState{

}

class LibrarydownloadingState extends LibrarydownloadState {
   final double progress;
  LibrarydownloadingState({
    required this.progress,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [progress];
}

class LibrarydownloadComplete extends LibrarydownloadState{
  
}

class Librarydownloadfailed extends LibrarydownloadState{

}