import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/presentation/widgets/post_widget.dart';

class ExploreScreen extends StatelessWidget {
  final List<Map<String, dynamic>?> postsWithUserData;
  final bool isVideo;
  final String currentUserId;
  final String clickedPostId;

  const ExploreScreen({
    super.key,
    required this.postsWithUserData,
    required this.isVideo,
    required this.currentUserId,
    required this.clickedPostId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: const Text(
          'Explore',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: postsWithUserData.length,
          itemBuilder: (context, index) {
            final post = postsWithUserData[index]!['post'] as PostModel;
            final user = postsWithUserData[index]!['user'] as UserModel;

            return PostWidget(
              postModel: post,
              postCubit: BlocProvider.of<PostCubit>(context),
              userModel: user,
              currentUserId: currentUserId,
            );
          }),
    );
  }
}
