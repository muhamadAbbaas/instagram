// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/presentation/screens/post/create_post_screen.dart';
import 'package:instagram/presentation/screens/explore/search_screen.dart';
import 'package:instagram/presentation/screens/new_feeds_screen.dart';
import 'package:instagram/presentation/screens/notification_screen.dart';
import 'package:instagram/presentation/screens/profile/profile.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  final List<Widget> mainScreens = [
    NewFeedsScreen(),
    SearchScreen(),
    CreatePostScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  Widget? currentOverlayScreen;

  void changeBottomNavIndex(int index) {
    currentOverlayScreen = null;
    currentIndex = index;
    emit(ChangeButtomNavSuccessState());
  }

  void navigateToOverlayScreen(Widget screen) {
    currentOverlayScreen = screen;
    emit(ChangeButtomNavSuccessState());
  }

  void closeOverlayScreen() {
    currentOverlayScreen = null;
    emit(ChangeButtomNavSuccessState());
  }
}
