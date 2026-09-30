import 'package:e_commerce_admin/features/users/data/models/admin_user_model.dart';
import 'package:equatable/equatable.dart';


abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersSuccess extends UsersState {
  final List<AdminUserModel> users;

  const UsersSuccess(
    this.users,
  );

  @override
  List<Object?> get props => [
        users,
      ];
}

class UsersCreating extends UsersState {
  final List<AdminUserModel> users;

  const UsersCreating(
    this.users,
  );

  @override
  List<Object?> get props => [
        users,
      ];
}

class UsersDeleting extends UsersState {
  final List<AdminUserModel> users;
  final String userId;

  const UsersDeleting({
    required this.users,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        users,
        userId,
      ];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(
    this.message,
  );

  @override
  List<Object?> get props => [
        message,
      ];
}