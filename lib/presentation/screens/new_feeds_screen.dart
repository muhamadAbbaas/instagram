// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable, unnecessary_string_interpolations, prefer_is_empty, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/presentation/screens/sharing_story_screen.dart';
import 'package:instagram/presentation/screens/story_screen.dart';

class NewFeedsScreen extends StatelessWidget {
  const NewFeedsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is PickedStoryImageSuccessState) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ShareStoryScreen(selectedImage: state.image);
            },
          ));
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        List updatedStoryList = [cubit.ownerStoriesList, ...cubit.storiesList];
        if (cubit.postsList.isEmpty) {
          return Center(
            child: Text('data'),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stories Section
            Container(
              height: 100,
              child: cubit.storiesList.length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                // Circular Profile Avatar
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(
                                            cubit.userModel!.profileImage!),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3),
                                // User Name
                                Text(
                                  'Your story',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              cubit.pickStoryImage();
                            },
                            icon: Icon(Icons.add_circle_outlined),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: updatedStoryList.length,
                      separatorBuilder: (context, index) => SizedBox(width: 7),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryScreen(
                                  storyModel: updatedStoryList[index],
                                ),
                              ),
                            );
                          },
                          child: index == 0
                              ? Column(
                                  children: [
                                    // Circular Profile Avatar
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.red,
                                            const Color.fromARGB(
                                                255, 252, 223, 180)
                                          ],
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(
                                          cubit.ownerStoriesList[0].userImage!,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    // User Name
                                    Text(
                                      '${cubit.ownerStoriesList[0].userName}',
                                      style: TextStyle(fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    // Circular Profile Avatar
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.red,
                                            const Color.fromARGB(
                                                255, 252, 223, 180)
                                          ],
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(
                                          cubit.storiesList[index - 1]
                                              .userImage!,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    // User Name
                                    Text(
                                      '${cubit.storiesList[index - 1].userName}',
                                      style: TextStyle(fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            // Feed Section
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: cubit.postsList.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post Header
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            '${cubit.postsList[index].userImage}',
                          ),
                        ),
                        title: Text(
                          '${cubit.postsList[index].userName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(Icons.more_horiz_rounded),
                      ),
                      // Post Image
                      Image.network(
                        '${cubit.postsList[index].postImage}', // Placeholder image
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      // Post Actions
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                cubit.postLikes(
                                  postId: cubit.postsId[index],
                                  isLiked: cubit.postsList[index].isLiked,
                                  likeNum: cubit.postsList[index].likeNum,
                                );
                              },
                              icon: Icon(Icons.favorite_border),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.comment),
                            SizedBox(width: 16),
                            Icon(Icons.send),
                            Spacer(),
                            Icon(Icons.bookmark_border),
                          ],
                        ),
                      ),
                      // Likes and Caption
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Liked by ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${cubit.postsList[index].userName}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${cubit.postsList[index].caption}',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              'View all 10 comments',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${cubit.postsList[index].dateTime}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
      // AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     'Instagram',
      //     style: TextStyle(
      //       fontSize: 32,
      //       color: Colors.black,
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         size: 24,
      //         Icons.favorite_border,
      //         color: Colors.black,
      //       ),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: Icon(
      //         size: 24,
      //         Icons.messenger_outline,
      //         color: Colors.black,
      //       ),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: Icon(
      //         size: 24,
      //         Icons.add_box_outlined,
      //         color: Colors.black,
      //       ),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),