// ignore_for_file: use_super_parameters, non_constant_identifier_names, prefer_const_constructors, unused_local_variable, deprecated_member_use, sort_child_properties_last, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/presentation/screens/profile/other_profile.dart';
import 'package:instagram/presentation/screens/profile/profile.dart';

import 'package:video_player/video_player.dart';

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
        final post = postsWithUserData[index]!['post'] as PostModel;
        final user = postsWithUserData[index]!['user'] as UserModel;
        var postCubit = PostCubit.get(context);
        return PostWidget(
          postModel: post,
          postCubit: postCubit,
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
      child: CircularProgressIndicator(),
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

// Widget buildPostsDetailsScreen({
//   required BuildContext context,
//   required PostState state,
//   required String clickedPostId,
//   required String currentUserId,
// }) {
//   if (state is PostLoadingState) {
//     return const Center(child: CircularProgressIndicator());
//   } else if (state is AllPostsWithUserLoadedState) {
//     final postsWithUserData = state.posts;

//     if (postsWithUserData.isEmpty) {
//       return const Center(
//         child: Text('No posts yet!'),
//       );
//     }

//     return ListView.builder(
//       itemCount: postsWithUserData.length,
//       itemBuilder: (context, index) {
//         final post = postsWithUserData[index]['post'] as PostModel;
//         final user = postsWithUserData[index]['user'] as UserModel;

//         return PostWidget(
//           postModel: post,
//           postCubit: BlocProvider.of<PostCubit>(context),
//           userModel: user,
//           currentUserId: currentUserId,
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

Widget buildUserPostsListScreen({
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

Widget toggleFollowingWidget({
  required BuildContext context,
  required UserModel userModel,
}) {
  final userCubit = context.read<UserCubit>();
  final postCubit = context.read<PostCubit>();

  // Ensure currentUser is not null
  if (userCubit.currentUser == null) {
    return Center(child: Text("User data not loaded"));
  }

  bool isFollowing = userModel.followers?.contains(
        userCubit.currentUser!.uid,
      ) ??
      false;

  return TextButton(
    onPressed: () async {
      try {
        if (userCubit.currentUser?.uid != null && userModel.uid != null) {
          if (isFollowing) {
            // Unfollow logic
            await userCubit.unfollowUser(
              currentUserId: userCubit.currentUser!.uid!,
              targetUserId: userModel.uid!,
            );
          } else {
            // Follow logic
            await userCubit.followUser(
              currentUserId: userCubit.currentUser!.uid!,
              targetUserId: userModel.uid!,
            );
          }
          postCubit.getSpecificUserData(userModel.uid!);
        }
      } catch (e) {
        // Display error if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action failed: $e')),
        );
      }
    },
    child: Text(
      isFollowing ? 'Unfollow' : 'Follow',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    style: TextButton.styleFrom(
      backgroundColor: isFollowing
          ? Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[200]
          : Colors.blue,
      foregroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : isFollowing
              ? Colors.black
              : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      fixedSize: Size(366, 30),
    ),
  );
}

class PostWidget extends StatefulWidget {
  final PostCubit postCubit;
  PostModel postModel;
  final UserModel userModel;
  final String currentUserId;

  PostWidget({
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
            ..initialize().then(
              (_) {
                setState(() {}); 
                _videoController!.play(); 
                _videoController!.setLooping(true); 
              },
            );
    }
  }

  @override
  void dispose() {
    _videoController?.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        //save state change locally
        if (state is PostLikedState &&
            state.postModel.postId == widget.postModel.postId) {
          setState(() {
            widget.postModel = state.postModel;
          });
        }
      },
      builder: (context, state) {
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
                      ? context
                          .read<AppCubit>()
                          .navigateToOverlayScreen(ProfileScreen())
                      : context.read<AppCubit>().navigateToOverlayScreen(
                          OtherUserProfileScreen(userModel: widget.userModel));
                },
              ),
              // Post Media (Image or Video)
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.black,
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
                      color:
                          widget.postModel.likes.contains(widget.userModel.uid!)
                              ? Colors.red
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                    ),
                  ),
                  FaIcon(FontAwesomeIcons.comment),
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
      },
    );
  }
}
