// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/presentation/screens/home_layout_screen.dart';
import 'package:instagram/presentation/screens/login_screen.dart';
import 'package:instagram/presentation/screens/splach_screen.dart';

class AppEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is CheckLoginStatusLoadingState) {
          return SplashScreen(); // Show loading screen
        } else if (state is CheckLoginStatusSuccessState) {
          return HomeLayoutScreen(); // Navigate to home screen
        } else {
          // Default to login screen if no user is logged in or an error occurs
          return LoginScreen();
        }
      },
    );
  }
}

