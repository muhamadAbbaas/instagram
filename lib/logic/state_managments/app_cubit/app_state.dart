// ignore_for_file: must_be_immutable

part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitialState extends AppState {}

final class CreatePostScreenState extends AppState {}

final class ChangeButtomNavSuccessState extends AppState {}

final class ChangeButtomNavErrorState extends AppState {}

final class NavigateToDetailsState extends AppState {}
