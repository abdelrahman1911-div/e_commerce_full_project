import 'package:e_commerce_full_project/features/home/profile/data/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  UserLoaded(this.user);
}

class UserUpdating extends UserState {
  final UserModel user;

  UserUpdating(this.user);
}

class UserUpdated extends UserState {
  final UserModel user;

  UserUpdated(this.user);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
} 
class UserProfileImageUpdated extends UserState {
  final String imageUrl;
  UserProfileImageUpdated(this.imageUrl);
  @override
  List<Object?> get props => [imageUrl];
}