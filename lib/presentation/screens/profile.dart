// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/presentation/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile Info Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: cubit.userModel!.profileImage == null
                          ? AssetImage('assets/images/download.jpg')
                          : NetworkImage(
                              cubit.userModel!.profileImage.toString()),
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
                padding: const EdgeInsets.symmetric(horizontal: 20,),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cubit.userModel!.userName.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      cubit.userModel!.bio==null?Text(''):
                      Text(cubit.userModel!.bio.toString()),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Edit Profile Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'profile_editing');
                  },
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
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
                          // GridView.builder(
                          //   padding: EdgeInsets.all(2),
                          //   gridDelegate:
                          //       SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount: 3,
                          //     mainAxisSpacing: 2,
                          //     crossAxisSpacing: 2,
                          //   ),
                          //   itemCount: 30,
                          //   itemBuilder: (context, index) {
                          //     return Container(
                          //       color: Colors.grey[300],
                          //       child: Image.network(
                          //         cubit.userModel!.profileImage.toString(),
                          //         fit: BoxFit.cover,
                          //       ),
                          //     );
                          //   },
                          // ),
                          Center(
                            child: Text("No posts",
                                style: TextStyle(color: Colors.grey)),
                          ),
                          // Tagged Photos
                          Center(
                            child: Text("No Vedios",
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
        );
      },
    );
  }
}
  // AppBar(
  //       backgroundColor: Colors.white,
  //       elevation: 1,
  //       title: Text(
  //         'username',
  //         style: TextStyle(
  //             color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
  //       ),
  //       actions: [
  //         IconButton(
  //             icon: Icon(Icons.add_box_outlined, color: Colors.black),
  //             onPressed: () {}),
  //         IconButton(
  //             icon: Icon(Icons.menu, color: Colors.black), onPressed: () {}),
  //       ],
  //     ),
      