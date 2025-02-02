// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:instagram/logic/model/user/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class SignInLoadingState extends UserState {}

class SignInSuccessState extends UserState {
  final String uid;
  SignInSuccessState(this.uid);
}

class SignInErrorState extends UserState {
  final String error;
  SignInErrorState(this.error);
}

class LogInLoadingState extends UserState {}

class LoginSuccessState extends UserState {
  final String uid;
  LoginSuccessState(this.uid);
}

class LoginErrorState extends UserState {
  final String error;
  LoginErrorState(this.error);
}

class CheckLoginStatusLoadingState extends UserState {}

class CheckLoginStatusSuccessState extends UserState {
  final UserModel user;

  CheckLoginStatusSuccessState(this.user);
}

class CheckLoginStatusErrorState extends UserState {
  final String error;

  CheckLoginStatusErrorState(this.error);
}

class LoggedOutState extends UserState {}

class LogOutErrorState extends UserState {
  final String error;

  LogOutErrorState(this.error);
}

class ProfileImagePickedState extends UserState {}

class ProfileImagePickErrorState extends UserState {}

class RemoveImageState extends UserState {}

class ProfileImageUploadingState extends UserState {}

class ProfileImageUploadedState extends UserState {
  String profileImage;
  ProfileImageUploadedState({
    required this.profileImage,
  });
}

class ProfileImageUploadErrorState extends UserState {}

// get user data
class GetUserDataLoadingState extends UserState {}

class GetUserDataLoadedState extends UserState {
  final UserModel user;
  GetUserDataLoadedState(this.user);
}

class GetUserDataLoadErrorState extends UserState {
  final String error;
  GetUserDataLoadErrorState(this.error);
}

// get all users
class GetAllUsersLoadingState extends UserState {}

class GetAllUsersLoadedState extends UserState {
  final List<UserModel> users;
  GetAllUsersLoadedState(this.users);
}

class GetAllUserDataLoadErrorState extends UserState {
  final String error;
  GetAllUserDataLoadErrorState(this.error);
}

class UserDateUpdatingState extends UserState {}

class UserDataUpdatedState extends UserState {}

class UserDataUpdateErrorState extends UserState {
  final String error;

  UserDataUpdateErrorState(this.error);
}

class FollowUserSuccessState extends UserState {}

class FollowUserErrorState extends UserState {
  final String error;

  FollowUserErrorState(this.error);
}

class UnfollowUserSuccessState extends UserState {}

class UnfollowUserErrorState extends UserState {
  final String error;

  UnfollowUserErrorState(this.error);
}
