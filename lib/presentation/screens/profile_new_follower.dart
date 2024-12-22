// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters, must_be_immutable
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace, avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/presentation/widgets/widgets.dart';

class OtherProfile extends StatelessWidget {
  //UserModel userModel;
  PostModel postModel;
  OtherProfile({
    Key? key,
    //required this.userModel,
    required this.postModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
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
            leadingWidth: 85,
            elevation: 1,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  postModel.userName.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
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
                          backgroundImage: postModel.userImage == null
                              ? AssetImage('assets/images/download.jpg')
                              : NetworkImage(
                                  postModel.userImage.toString(),
                                ),
                        ),
                        SizedBox(width: 16),
                        // Follower Counts
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildInfo("Posts", "100"),
                              buildInfo("Followers", "1.5k"),
                              buildInfo("Following", "300"),
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
                            postModel.userName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text('This is a bio that describes the user.'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Edit Profile Button
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Follow',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            fixedSize: Size(366, 30),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Message',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(239, 239, 239, 1),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0)),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(239, 239, 239, 1),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0)),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(239, 239, 239, 1),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0)),
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
                        TabBar(
                          indicatorColor: Colors.black,
                          tabs: [
                            Tab(icon: Icon(Icons.grid_on, color: Colors.black)),
                            Tab(
                                icon: Icon(Icons.video_collection_outlined,
                                    color: Colors.black)),
                            Tab(
                                icon: Icon(Icons.person_pin_outlined,
                                    color: Colors.black)),
                          ],
                        ),
                        Container(
                          height: 400, // Height of the TabBarView
                          child: TabBarView(
                            children: [
                              // Grid View of Posts
                              GridView.builder(
                                padding: EdgeInsets.all(2),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                ),
                                itemCount: 30,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Image.network(
                                      postModel.postImage.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                              // Tagged Photos
                              Center(
                                child: Text("No Tagged Photos",
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
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black26,
            currentIndex: 0,
            onTap: null,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shop_outlined), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: ''),
            ],
          ),
        );
      },
    );
  }
}
