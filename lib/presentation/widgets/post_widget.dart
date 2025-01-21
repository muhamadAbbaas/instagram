// ignore_for_file: use_super_parameters, non_constant_identifier_names, prefer_const_constructors, unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/presentation/screens/other_user_profile.dart';
import 'package:instagram/presentation/screens/profile.dart';

import 'package:video_player/video_player.dart';

class PostWidget extends StatefulWidget {
  final PostCubit postCubit;
  final PostModel postModel;
  final UserModel userModel;
  final String currentUserId;

  const PostWidget({
    Key? key,
    required this.postCubit,
    required this.postModel,
    required this.userModel,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.postModel.postType == 'vedio') {
      _videoController =
          VideoPlayerController.network(widget.postModel.postImage)
            ..initialize().then((_) {
              setState(() {}); // Rebuild to show the video
              _videoController!.play(); // Auto-play
              _videoController!.setLooping(true); // Loop the video
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose(); // Properly dispose of the video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.userModel.profileImage!),
            ),
            title: Text(
              widget.userModel.userName!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.more_horiz_rounded),
            onTap: () {
              widget.userModel.uid == widget.currentUserId
                  ? AppCubit.get(context).navigateToOverlayScreen(
                      ProfileScreen(),
                    )
                  : AppCubit.get(context).navigateToOverlayScreen(
                      OtherUserPofileScreen(
                          userModel: widget.userModel,
                          postModel: widget.postModel),
                    );
            },
          ),
          // Post Media (Image or Video)
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.black, // Background color for videos
            child: widget.postModel.postType == 'vedio'
                ? _videoController != null &&
                        _videoController!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                    : Center(child: CircularProgressIndicator())
                : Image.network(
                    widget.postModel.postImage,
                    fit: BoxFit.cover,
                  ),
          ),
          // Post Actions
          Row(
            children: [
              IconButton(
                onPressed: () {
                  widget.postCubit
                      .toggleLike(widget.postModel, widget.userModel.uid!);
                },
                icon: Icon(
                  widget.postModel.likes.contains(widget.userModel.uid!)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.postModel.likes.contains(widget.userModel.uid!)
                      ? Colors.red
                      : Colors.black,
                ),
              ),
              Icon(Icons.comment),
              SizedBox(width: 14),
              Icon(Icons.send),
              Spacer(),
              Icon(Icons.bookmark_border),
            ],
          ),
          // Post Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.postModel.likes.length == 1
                      ? '${widget.postModel.likes.length} like'
                      : '${widget.postModel.likes.length} likes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      widget.userModel.userName!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(widget.postModel.caption),
                  ],
                ),
                Text(
                  'View all comments',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '${widget.postModel.timestamp}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
          setState(() {}); // Rebuild to show the initialized video.
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


Widget buildHomeScreenPosts({
  required BuildContext context,
  required PostState state,
  required String currentUserId,
}) {
  if (state is PostLoadingState) {
    return const Center(child: CircularProgressIndicator());
  } else if (state is AllPostsWithUserLoadedState) {
    final postsWithUserData = state.posts;

    if (postsWithUserData.isEmpty) {
      return const Center(
        child: Text('No posts yet!'),
      );
    }

    return ListView.builder(
      itemCount: postsWithUserData.length,
      itemBuilder: (context, index) {
        final post = postsWithUserData[index]['post'] as PostModel;
        final user = postsWithUserData[index]['user'] as UserModel;

        return PostWidget(
          postModel: post,
          postCubit: BlocProvider.of<PostCubit>(context),
          userModel: user,
          currentUserId: currentUserId,
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
}

// Widget buildSearchScreenPosts(BuildContext context, PostState state) {
//   if (state is PostLoadingState) {
//     return const Center(child: CircularProgressIndicator());
//   } else if (state is AllPostsWithUserLoadedState) {
//     final postsWithUserData = state.posts;

//     if (postsWithUserData.isEmpty) {
//       return const Center(
//         child: Text('No posts yet!'),
//       );
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.all(8.0),
//       itemCount: postsWithUserData.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 4,
//         mainAxisSpacing: 4,
//       ),
//       itemBuilder: (context, index) {
//         final post = postsWithUserData[index]['post'] as PostModel;
//         final user = postsWithUserData[index]['user'] as UserModel;
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ExploreScreen(
//                     clickedPostId: post.postId,
//                   ),
//                 ));
//           },
//           child: Container(
//             color: Colors.grey[300],
//             child: Image.network(
//               post.postImage,
//               fit: BoxFit.cover,
//             ),
//           ),
//         );
//       },
//     );
//   } else if (state is NoPostsState) {
//     return const Center(
//       child: Text('No posts yet! Create your first post.'),
//     );
//   } else if (state is PostLoadedErrorState) {
//     return Center(
//       child: Text('Error loading posts: ${state.error}'),
//     );
//   } else {
//     return const Center(
//       child: Text('No Posts Found'),
//     );
//   }
// }

Widget buildPostsDetailsScreen({
  required BuildContext context,
  required PostState state,
  required String clickedPostId,
  required String currentUserId,
}) {
  if (state is PostLoadingState) {
    return const Center(child: CircularProgressIndicator());
  } else if (state is AllPostsWithUserLoadedState) {
    final postsWithUserData = state.posts;

    if (postsWithUserData.isEmpty) {
      return const Center(
        child: Text('No posts yet!'),
      );
    }

    return ListView.builder(
      itemCount: postsWithUserData.length,
      itemBuilder: (context, index) {
        final post = postsWithUserData[index]['post'] as PostModel;
        final user = postsWithUserData[index]['user'] as UserModel;

        return PostWidget(
          postModel: post,
          postCubit: BlocProvider.of<PostCubit>(context),
          userModel: user,
          currentUserId: currentUserId,
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
}

Widget buildUserPostsDetailsScreen({
  required BuildContext context,
  required PostState state,
  required String clickedPostId,
  required String currentUserId,
}) {
  if (state is PostLoadingState) {
    return const Center(child: CircularProgressIndicator());
  } else if (state is UserPostsWithDataLoadedState) {
    final userPosts = state.posts;
    final userData = state.user;

    if (userPosts.isEmpty) {
      return const Center(
        child: Text('No posts yet!'),
      );
    }

    return ListView.builder(
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        final post = userPosts[index];

        return PostWidget(
          postModel: post,
          postCubit: BlocProvider.of<PostCubit>(context),
          userModel: userData,
          currentUserId: currentUserId,
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
}
