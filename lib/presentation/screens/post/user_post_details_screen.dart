// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/presentation/widgets/post_widget.dart';

class UserPostsListScreen extends StatelessWidget {
  final String clickedUserId;
  final String clickedPostId;
  final String currentUserId;

  UserPostsListScreen({
    super.key,
    required this.clickedUserId,
    required this.clickedPostId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostCubit>(context).getSpecificUserData(clickedUserId);
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
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return buildUserPostsListScreen(
            context: context,
            state: state,
            clickedPostId: clickedPostId,
            currentUserId: currentUserId,
          );
        },
      ),
    );
  }
}
