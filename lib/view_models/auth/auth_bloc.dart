import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noBroker_user_dashboard/repositories/auth_repository.dart';

import '../../core/network/api_exception.dart';
import '../../core/storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }
  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await authRepository.login(event.model);

      await TokenStorage.saveToken(response.accessToken);
      await TokenStorage.saveUser(response.user);

      emit(AuthLoginSuccess(response));
    } on ApiException catch (error) {
      emit(AuthError(error.message));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await TokenStorage.clearToken();

      emit(LogoutSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.register(event.model);

      emit(AuthRegisterSuccess(res));
    } on ApiException catch (error) {
      emit(AuthError(error.message));
    }
  }
}
