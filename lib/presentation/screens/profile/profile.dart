// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, sort_child_properties_last, unnecessary_string_interpolations, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/presentation/widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userCubit = BlocProvider.of<UserCubit>(context);
    final postCubit = BlocProvider.of<PostCubit>(context);
    if (userCubit.currentUser == null) {
      return const Center(child: Text("Error loading user data."));
    }
    final uid = userCubit.currentUser!.uid!;
    postCubit.getSpecificUserData(uid);
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (userCubit.currentUser == null) {
          return const Center(
            child: Text("Error loading user data."),
          );
        }
        return Scaffold(
          key: _scaffoldKey,
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
            actions: [
              // Settings Icon
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.squarePlus,
                  size: 22,
                ),
                onPressed: () {},
              ),
              // Drawer Icon
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ],
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
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'profile_editing');
                    },
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[900]
                              : Colors.grey[200],
                      foregroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      fixedSize: Size(366, 30),
                    ),
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
                            buildUserPosts(
                              postCubit,
                              userCubit.currentUser!.uid!,
                            ),
                            Center(
                              child: Text(
                                "No Videos",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Center(
                              child: Text(
                                "No Tagged Photos",
                                style: TextStyle(color: Colors.grey),
                              ),
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
