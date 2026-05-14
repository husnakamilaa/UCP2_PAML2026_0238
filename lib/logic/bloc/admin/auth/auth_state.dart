import 'package:driveease/data/models/auth_request.dart';
import 'package:driveease/data/models/users.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthSuccess extends AuthState {
  final UserModel users; 
  AuthSuccess(this.users);
}

class Unauthenticated extends AuthState {}