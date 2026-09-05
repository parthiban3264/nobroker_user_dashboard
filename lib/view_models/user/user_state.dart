import '../../models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final List<UserModel> users;

  UserSuccess(this.users);
}

class GetSingleUserSuccess extends UserState {
  final UserModel user;
  GetSingleUserSuccess(this.user);
}

class UpdateUserSuccess extends UserState {}

class DeleteUserSuccess extends UserState {
  final bool user;

  DeleteUserSuccess(this.user);
}

class UserError extends UserState {
  final String msg;
  UserError(this.msg);
}
