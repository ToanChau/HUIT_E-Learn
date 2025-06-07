// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ChangepassState extends Equatable {
  @override
  List<Object?> get props => [];
}
class ChangepassInitialState extends ChangepassState {}

class ChangingPassState extends ChangepassState {}

class ChangePassCompleteState extends ChangepassState{}

class ChangePassErrorState extends ChangepassState {
  final String error;
  ChangePassErrorState({
    required this.error,
  });
  @override
  List<Object?> get props => [error];
}
