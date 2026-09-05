import 'package:noBroker_user_dashboard/models/user_model.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final UserModel model;
  LoginRequested(this.model);
}

class LogoutRequested extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final UserModel model;
  RegisterRequested(this.model);
}
