import 'package:equatable/equatable.dart';

import 'package:huit_elearn/models/documents.dart';

class LibrarydownloadEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class LibrarydownloadInitialEvent extends LibrarydownloadEvent{

}

class LibrarydownloadStartEvent extends LibrarydownloadEvent {
  final Document document;
  LibrarydownloadStartEvent({
    required this.document,
  });
  @override
  List<Object?> get props => [document];
}
