import 'package:e_commerce_admin/features/users/cubit/user_state.dart';
import 'package:e_commerce_admin/features/users/data/models/admin_user_model.dart';
import 'package:e_commerce_admin/features/users/data/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class UsersCubit extends Cubit<UsersState> {
  final UsersRepository _repository;

  UsersCubit(
    this._repository,
  ) : super(UsersInitial());

  Future<void> getAllUsers() async {
    emit(
      UsersLoading(),
    );

    try {
      final users =
          await _repository.getAllUsers();

      emit(
        UsersSuccess(users),
      );
    } catch (e) {
      emit(
        UsersError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    final currentUsers =
        _getCurrentUsers();

    emit(
      UsersCreating(
        currentUsers,
      ),
    );

    try {
      await _repository.createUser(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );

      await getAllUsers();
    } catch (e) {
      emit(
        UsersError(
          e.toString(),
        ),
      );

      emit(
        UsersSuccess(
          currentUsers,
        ),
      );
    }
  }

  Future<void> deleteUser(
    String userId,
  ) async {
    final currentUsers =
        _getCurrentUsers();

    emit(
      UsersDeleting(
        users: currentUsers,
        userId: userId,
      ),
    );

    try {
      await _repository.deleteUser(
        userId,
      );

      await getAllUsers();
    } catch (e) {
      emit(
        UsersError(
          e.toString(),
        ),
      );

      emit(
        UsersSuccess(
          currentUsers,
        ),
      );
    }
  }

  List<AdminUserModel> _getCurrentUsers() {
    final currentState = state;

    if (currentState is UsersSuccess) {
      return currentState.users;
    }

    if (currentState is UsersCreating) {
      return currentState.users;
    }

    if (currentState is UsersDeleting) {
      return currentState.users;
    }

    return [];
  }
}