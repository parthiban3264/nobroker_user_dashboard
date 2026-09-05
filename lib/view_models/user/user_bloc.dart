import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/api_exception.dart';
import '../../repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc(this.userRepository) : super(UserInitial()) {
    on<GetAllUser>(onGetAllUser);
    on<GetSingleUser>(onGetSingleUser);
    on<UpdateUser>(onUpdateUser);
    on<DeleteUser>(onDeleteUser);
  }

  Future<void> onGetAllUser(GetAllUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final res = await userRepository.getAllUser();

      emit(UserSuccess(res));
    } on ApiException catch (error) {
      emit(UserError(error.message));
    }
  }

  Future<void> onGetSingleUser(
    GetSingleUser event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final res = await userRepository.getSingleUser(event.model);

      emit(GetSingleUserSuccess(res));
    } on ApiException catch (error) {
      emit(UserError(error.message));
    }
  }

  Future<void> onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.updateUser(event.model);

      emit(UpdateUserSuccess());
    } on ApiException catch (error) {
      emit(UserError(error.message));
    }
  }

  Future<void> onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final res = await userRepository.deleteUser(event.model);

      emit(DeleteUserSuccess(res));
    } on ApiException catch (error) {
      emit(UserError(error.message));
    }
  }
}
