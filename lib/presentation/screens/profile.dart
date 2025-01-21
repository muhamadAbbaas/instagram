// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, sort_child_properties_last, unnecessary_string_interpolations, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/presentation/widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        var userCubit = UserCubit.get(context);
        var postCubit = PostCubit.get(context);
        postCubit.getSpecificUserData(userCubit.currentUser?.uid ?? "");

        if (userCubit.currentUser == null) {
          return const Center(
            child: Text("Error loading user data."),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            title: Text(
              '${userCubit.currentUser!.userName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          endDrawer: buildDrawer(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: userCubit.currentUser!.profileImage ==
                                null
                            ? AssetImage('assets/images/download.jpg')
                            : NetworkImage(
                                userCubit.currentUser!.profileImage.toString(),
                              ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FutureBuilder<int>(
                              future: postCubit
                                  .getPostsCount(userCubit.currentUser!.uid!),
                              builder: (context, snapshot) {
                                return buildInfo(
                                    "Posts", snapshot.data?.toString() ?? "0");
                              },
                            ),
                            buildInfo(
                                'Followers',
                                userCubit.currentUser!.followers!.length
                                    .toString()),
                            buildInfo(
                                'Following',
                                userCubit.currentUser!.following!.length
                                    .toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userCubit.currentUser!.userName.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        userCubit.currentUser!.bio == null
                            ? Text('')
                            : Text(userCubit.currentUser!.bio.toString()),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'profile_editing');
                    },
                    child: const Text(
                      'Edit Profile',
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ).merge(Theme.of(context).outlinedButtonTheme.style),
                  ),
                ),
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        indicatorColor: Colors.black,
                        tabs: [
                          Tab(icon: Icon(Icons.grid_on)),
                          Tab(icon: Icon(Icons.video_collection_outlined)),
                          Tab(icon: Icon(Icons.person_pin_outlined)),
                        ],
                      ),
                      Container(
                        height: 400,
                        child: TabBarView(
                          children: [
                            buildTabViewPosts(
                                postCubit, userCubit.currentUser!.uid!),
                            Center(
                              child: Text("No Videos",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            Center(
                              child: Text("No Tagged Photos",
                                  style: TextStyle(color: Colors.grey)),
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
        );
      },
    );
  }
}
