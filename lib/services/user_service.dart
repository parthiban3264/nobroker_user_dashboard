import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../core/storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class UserServices {
  UserServices();

  //Get all User Data
  Future<List<UserModel>> getAllUser() async {
    final token = await TokenStorage.getToken();
    final res = await DioClient.dio.get(
      'api/user/getALl',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List<dynamic> data = res.data['users'];

    return data
        .map((item) => UserModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  //Get Single User Data
  Future<UserModel> getSingleUser(UserModel model) async {
    final res = await DioClient.dio.get(
      'api/user/getById/${model.id}',
      data: model.toJson(),
    );
    return UserModel.fromJson(Map<String, dynamic>.from(res.data['user']));
  }

  //Update User Data
  Future<UserModel> updateUser(UserModel model) async {
    final res = await DioClient.dio.put(
      'api/user/update/${model.id}',
      data: model.toJson(),
    );
    return UserModel.fromJson(Map<String, dynamic>.from(res.data['user']));
  }

  //Delete User Data
  Future<bool> deleteUser(UserModel model) async {
    final res = await DioClient.dio.delete('api/user/delete/${model.id}');
    return res.statusCode == 200 || res.statusCode == 201;
  }
}
