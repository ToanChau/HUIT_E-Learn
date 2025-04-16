
import 'package:equatable/equatable.dart';
import 'package:huit_elearn/models/users.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthSignUp extends AuthEvent {
  final UserModel user;
  final String password;

  AuthSignUp({required this.user, required this.password});

  @override
  List<Object> get props => [user, password];
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({required this.email, required this.password});

  @override
  List<Object> get props => [email,password];
}
class AuthCheckLogin extends AuthEvent {}


class AuthSignOut extends AuthEvent {}

