// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ChangepassEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangepassInitialEvent extends ChangepassEvent{
}

class ChangingpassEvent extends ChangepassEvent {
  final String currentPass;
  final String newPass;
  final String confirmPass;
  ChangingpassEvent({
    required this.currentPass,
    required this.newPass,
    required this.confirmPass,
  });
  @override
  List<Object?> get props => [currentPass,newPass,confirmPass];
}

