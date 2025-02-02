// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/presentation/screens/explore/explore_screen.dart';
import 'package:instagram/presentation/widgets/profile_widgets.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostCubit>(context).getAllUsersPosts();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: const Text(
          'Search',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllPostsWithUserLoadedState) {
            final postsWithUserData = state.posts;

            if (postsWithUserData.isEmpty) {
              return const Center(
                child: Text('No posts yet!'),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: postsWithUserData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                final post = postsWithUserData[index]!['post'] as PostModel;

                return GestureDetector(
                  onTap: () {
                    final currentUserId =
                        UserCubit.get(context).currentUser!.uid;
                    final isVideo = post.postType == 'vedio';
                    final filteredPosts = postsWithUserData.where((element) {
                      final currentPost = element!['post'] as PostModel;
                      return currentPost.postType ==
                          (isVideo ? 'vedio' : 'image');
                    }).toList();

                    AppCubit.get(context).navigateToOverlayScreen(
                      ExploreScreen(
                        postsWithUserData: filteredPosts,
                        isVideo: isVideo,
                        clickedPostId: post.postId,
                        currentUserId: currentUserId!,
                      ),
                    );
                  },
                  child: PostMediaThumbnail(post: post),
                );
              },
            );
          } else if (state is NoPostsState) {
            return const Center(
              child: Text('No posts yet! Create your first post.'),
            );
          } else if (state is PostLoadedErrorState) {
            return Center(
              child: Text('Error loading posts: ${state.error}'),
            );
          } else {
            return const Center(
              child: Text('No Posts Found'),
            );
          }
        },
      ),
    );
  }
}
