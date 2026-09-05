import '../core/network/dio_client.dart';
import '../models/user_model.dart';

class AuthServices {
  AuthServices();

  Future<TokenResponse> login(UserModel model) async {
    final res = await DioClient.dio.post(
      'api/auth/login',
      data: {'email': model.email, 'password': model.password},
    );
    return TokenResponse.fromJson(res.data);
  }

  Future<UserModel> register(UserModel model) async {
    final res = await DioClient.dio.post(
      'api/auth/register',
      data: model.toJson(),
    );
    return UserModel.fromJson(Map<String, dynamic>.from(res.data['user']));
  }
}
