// ignore_for_file: prefer_const_constructors, unused_element, await_only_futures, use_build_context_synchronously, deprecated_member_use, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/logic/state_managments/theme_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/presentation/screens/post/user_post_details_screen.dart';
import 'package:video_player/video_player.dart';

void showLoadingDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(width: 16),
            Text(message),
          ],
        ),
      );
    },
  );
}

void hideDialog(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

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
            await context.read<UserCubit>().logout(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: Text(
            Theme.of(context).brightness == Brightness.dark
                ? "Light Theme"
                : "Dark Theme",
          ),
          onTap: () {
            context.read<ThemeCubit>().toggleTheme();
          },
        ),
      ],
    ),
  );
}

Widget buildUserPosts(PostCubit postCubit, String currentUserId) {
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
              context.read<AppCubit>().navigateToOverlayScreen(
                    UserPostsListScreen(
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

class PostMediaThumbnail extends StatefulWidget {
  final PostModel post;
  const PostMediaThumbnail({super.key, required this.post});
  @override
  State<PostMediaThumbnail> createState() => _PostMediaThumbnailState();
}

class _PostMediaThumbnailState extends State<PostMediaThumbnail> {
  VideoPlayerController? _videoController;
  @override
  void initState() {
    super.initState();
    if (widget.post.postType == 'vedio') {
      _videoController = VideoPlayerController.network(widget.post.postImage)
        ..initialize().then((_) {
          setState(() {});
        })
        ..setLooping(true);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.postType == 'vedio' && _videoController != null) {
      return _videoController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
    } else {
      return Image.network(
        widget.post.postImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 40,
        ),
      );
    }
  }
}
