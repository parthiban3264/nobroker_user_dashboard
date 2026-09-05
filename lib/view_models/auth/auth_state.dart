import '../../models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final TokenResponse tokenResponse;
  AuthLoginSuccess(this.tokenResponse);
}

class LogoutSuccess extends AuthState {}

class AuthRegisterSuccess extends AuthState {
  final UserModel user;

  AuthRegisterSuccess(this.user);
}

class AuthError extends AuthState {
  final String msg;
  AuthError(this.msg);
}
