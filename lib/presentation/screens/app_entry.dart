// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/presentation/screens/home_layout_screen.dart';
import 'package:instagram/presentation/screens/auth/login_screen.dart';

class AppEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is CheckLoginStatusLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CheckLoginStatusSuccessState) {
          return HomeLayoutScreen();
        } else if (state is CheckLoginStatusErrorState ||
            UserCubit.get(context).currentUser == null) {
          return LoginScreen();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
