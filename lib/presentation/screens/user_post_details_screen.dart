// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/presentation/widgets/post_widget.dart';

class UserPostDetailsScreen extends StatelessWidget {
  final String clickedUserId;
  final String clickedPostId;
  final String currentUserId;

  UserPostDetailsScreen({
    super.key,
    required this.clickedUserId,
    required this.clickedPostId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UserCubit()),
          BlocProvider(
              create: (context) =>
                  PostCubit()..getSpecificUserData(clickedUserId)),
        ],
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            return buildUserPostsDetailsScreen(
              context: context,
              state: state,
              clickedPostId: clickedPostId,
              currentUserId: currentUserId,
            );
          },
        ),
      ),
    );
  }
}
