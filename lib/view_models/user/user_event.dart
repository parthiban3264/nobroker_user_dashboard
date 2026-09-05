import 'package:noBroker_user_dashboard/models/user_model.dart';

abstract class UserEvent {}

// class GetAllUser extends UserEvent {
//   final UserModel model;
//   GetAllUser(this.model);
// }

class GetAllUser extends UserEvent {
  GetAllUser();
}

class GetSingleUser extends UserEvent {
  final UserModel model;
  GetSingleUser(this.model);
}

class UpdateUser extends UserEvent {
  final UserModel model;
  UpdateUser(this.model);
}

class DeleteUser extends UserEvent {
  final UserModel model;
  DeleteUser(this.model);
}
