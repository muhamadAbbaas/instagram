// ignore_for_file: prefer_const_constructors, unused_element, await_only_futures, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/local/cash_helper.dart';
import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/logic/state_managments/theme_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/presentation/screens/user_post_details_screen.dart';
import 'package:instagram/presentation/widgets/post_widget.dart';

Widget buildInfo(String label, String? count) {
  return Column(
    children: [
      Text(
        count!,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      Text(label),
    ],
  );
}

Widget buildDrawer(BuildContext context) {
  return Drawer(
    elevation: 5,
    width: 200,
    child: ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onTap: () async {
            await UserCubit.get(context).logout;
            CacheHelper.deleteData(key: 'uId');
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: const Text("Dark Theme"),
          onTap: () {
            BlocProvider.of<ThemeCubit>(context).toggleTheme(); 
          },
        ),
      ],
    ),
  );
}

Widget buildTabViewPosts(PostCubit postCubit, String currentUserId) {
  return BlocBuilder<PostCubit, PostState>(
    builder: (context, postState) {
      if (postState is PostLoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (postState is UserPostsWithDataLoadedState) {
        if (postState.posts.isEmpty) {
          return buildEmptyState("No posts yet.");
        }
        return buildPostsGrid(postState.posts, currentUserId);
      } else if (postState is PostLoadedErrorState) {
        return buildEmptyState("Error loading posts.");
      } else {
        return buildEmptyState("No posts yet.");
      }
    },
  );
}

Widget buildPostsGrid(List<PostModel> posts, String currentUserId) {
  return Column(
    children: [
      GridView.builder(
        padding: const EdgeInsets.all(2),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              AppCubit.get(context).navigateToOverlayScreen(
                UserPostDetailsScreen(
                  clickedPostId: posts[index].postId,
                  clickedUserId: posts[index].uid,
                  currentUserId: currentUserId,
                ),
              );
            },
            child: PostMediaThumbnail(post: posts[index]),
          );
        },
      ),
    ],
  );
}

Widget buildEmptyState(String message) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_on,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}
