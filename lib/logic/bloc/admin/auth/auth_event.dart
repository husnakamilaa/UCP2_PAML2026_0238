import 'package:driveease/data/models/auth_request.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final AuthRequest request;
  RegisterRequested(this.request);
}


class LogoutRequested extends AuthEvent {}
class CheckAuthStatus extends AuthEvent {}