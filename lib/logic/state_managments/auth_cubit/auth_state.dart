// ignore_for_file: must_be_immutable

part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SignUpLoadingState extends AuthState {}

final class SignUpSuccessState extends AuthState {}

final class SignUpErrorState extends AuthState {}

final class SetUserDataSuccessState extends AuthState {}

final class SetUserDataErrorState extends AuthState {}



final class LoginLoadingState extends AuthState {}

final class LoginSuccessState extends AuthState {
  String? uId;
  LoginSuccessState({
    this.uId,
  });
}

final class LoginErrorState extends AuthState {
  String? error;
  LoginErrorState({
    this.error,
  });
}

final class LogoutSuccessState extends AuthState {}

final class LogoutErrorState extends AuthState {}


