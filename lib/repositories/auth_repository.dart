import '../core/utils/error_handler.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthServices authService;

  AuthRepository(this.authService);

  Future<TokenResponse> login(UserModel model) async {
    try {
      return await authService.login(model);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<UserModel> register(UserModel model) async {
    try {
      return await authService.register(model);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
