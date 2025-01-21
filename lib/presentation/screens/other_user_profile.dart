// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, sort_child_properties_last, unnecessary_string_interpolations, prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/presentation/widgets/profile_widgets.dart';

class OtherUserPofileScreen extends StatelessWidget {
  final UserModel userModel;
  final PostModel postModel;

  const OtherUserPofileScreen({
    super.key,
    required this.userModel,
    required this.postModel,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit()..getSpecificUserData(userModel.uid!),
      child: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PostLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserPostsWithDataLoadedState) {
            final postModels = state.posts;
            final userModels = state.user;
            return BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {},
              builder: (context, state) {
                var postCubit = PostCubit.get(context);
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    foregroundColor:
                        Theme.of(context).appBarTheme.foregroundColor,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    leadingWidth: 50,
                    elevation: 1,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userModel.userName.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                            size: 24,
                          ),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.more_horiz, color: Colors.black),
                          onPressed: () {}),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          // Profile Info Section
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Profile Picture
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: userModel.profileImage ==
                                          null
                                      ? AssetImage('assets/images/download.jpg')
                                      : NetworkImage(
                                          userModel.profileImage.toString(),
                                        ),
                                ),
                                SizedBox(width: 16),
                                // Follower Counts
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      FutureBuilder<int>(
                                        future: postCubit
                                            .getPostsCount(postModel.uid),
                                        builder: (context, snapshot) {
                                          return buildInfo("Posts",
                                              snapshot.data?.toString() ?? "0");
                                        },
                                      ),
                                      buildInfo(
                                          'Followers',
                                          userModel.followers!.length
                                              .toString()),
                                      buildInfo(
                                          'Following',
                                          userModel.following!.length
                                              .toString()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Username and Bio
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userModel.userName.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'This is a bio that describes the user.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Edit Profile Button
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: BlocConsumer<UserCubit, UserState>(
                                  listener: (context, state) {
                                    if (state is FollowUserSuccessState ||
                                        state is UnfollowUserSuccessState) {
                                      PostCubit.get(context)
                                          .getSpecificUserData(userModel.uid!);
                                    }
                                  },
                                  builder: (context, state) {
                                    bool isFollowing = userModel.followers
                                            ?.contains(UserCubit.get(context)
                                                .currentUser!
                                                .uid) ??
                                        false;

                                    return TextButton(
                                      onPressed: () {
                                        if (isFollowing) {
                                          BlocProvider.of<UserCubit>(context)
                                              .unfollowUser(
                                            UserCubit.get(context)
                                                .currentUser!
                                                .uid!, // Current user's ID
                                            userModel.uid!, // Target user's ID
                                          );
                                        } else {
                                          BlocProvider.of<UserCubit>(context)
                                              .followUser(
                                            UserCubit.get(context)
                                                .currentUser!
                                                .uid!, // Current user's ID
                                            userModel.uid!, // Target user's ID
                                          );
                                        }
                                      },
                                      child: Text(
                                        isFollowing ? 'Unfollow' : 'Follow',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: isFollowing
                                            ? Colors.grey[300]
                                            : Colors
                                                .blue, // Grey for Unfollow, Blue for Follow
                                        foregroundColor: isFollowing
                                            ? Colors.black
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.0)),
                                        fixedSize: Size(366, 30),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Message',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue[500],
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.0)),
                                        fixedSize: Size(111, 30),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Subscribe',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue[500],
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.0)),
                                        fixedSize: Size(111, 30),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Contact',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue[500],
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.0)),
                                        fixedSize: Size(111, 30),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Post Tabs (Grid & Tagged)
                          DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                const TabBar(
                                  indicatorColor: Colors.black,
                                  tabs: [
                                    Tab(icon: Icon(Icons.grid_on)),
                                    Tab(
                                        icon: Icon(
                                            Icons.video_collection_outlined)),
                                    Tab(icon: Icon(Icons.person_pin_outlined)),
                                  ],
                                ),
                                Container(
                                  height: 400, // Height of the TabBarView
                                  child: TabBarView(
                                    children: [
                                      //Grid View of Posts
                                      buildTabViewPosts(postCubit, ''),
                                      // Tagged Photos
                                      Center(
                                        child: Text("No Vedios",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                      Center(
                                        child: Text("No Tagged Photos",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
