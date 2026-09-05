import 'package:noBroker_user_dashboard/services/user_service.dart';

import '../core/utils/error_handler.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserServices userService;
  UserRepository(this.userService);

  //Get ALl User
  Future<List<UserModel>> getAllUser() async {
    try {
      return await userService.getAllUser();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  //Get Single User
  Future<UserModel> getSingleUser(UserModel model) async {
    try {
      return await userService.getSingleUser(model);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // Update User Data
  Future<UserModel> updateUser(UserModel model) async {
    try {
      return await userService.updateUser(model);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<bool> deleteUser(UserModel model) async {
    try {
      return await userService.deleteUser(model);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
