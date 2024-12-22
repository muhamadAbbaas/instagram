// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable, unnecessary_string_interpolations, prefer_is_empty, must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/model/story/story_model.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/presentation/screens/profile_new_follower.dart';
import 'package:instagram/presentation/screens/sharing_story_screen.dart';

class NewFeedsScreen extends StatelessWidget {
  String? userId;
  List<StoryModel>? stories;
  List<PostModel>? posts = [];
  List<UserModel>? users = [];

  NewFeedsScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(listener: (context, state) {
      if (state is PickedStoryImageSuccessState) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ShareStoryScreen(selectedImage: state.image);
          },
        ));
      }
      if (state is GetStoriesSuccessState) {
        stories = state.stories;
      }
      if (state is PostLoading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      }
      if (state is PostLoaded) {
        posts = state.posts;
      }
    }, builder: (context, state) {
      var cubit = AppCubit.get(context);
      if (posts!.length != 0) {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: posts!.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Header
                ListTile(
                  leading: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return OtherProfile(
                            postModel: posts![index],
                            //userModel: users![index],
                          );
                        },
                      ));
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        '${posts![index].userImage}',
                      ),
                    ),
                  ),
                  title: Text(
                    '${posts![index].userName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(Icons.more_horiz_rounded),
                ),
                // Post Image
                Image.network(
                  '${posts![index].postImage}',
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
                          cubit.toggleLike(
                              posts![index], cubit.userModel!.uId!);
                        },
                        icon: Icon(
                          posts![index].likes!.contains(cubit.userModel!.uId!)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: posts![index]
                                  .likes!
                                  .contains(cubit.userModel!.uId!)
                              ? Colors.red
                              : Colors.grey,
                        ),
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
                            '${posts![index].userName}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${posts![index].caption}',
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
                        '${posts![index].dateTime}',
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
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}

// Column(
//           children: [
//             SizedBox(
//               height: 120,
//               child: stories!.length > 0
//                   ? ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: stories!.length,
//                       separatorBuilder: (context, index) => SizedBox(width: 10),
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             if (stories![index].hasStory!) {
//                               // Handle story click
//                               print(
//                                   'Viewing story for ${stories![index].userName}');
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => StoryScreen(
//                                         storyModel: stories![index]),
//                                   ));
//                             } else {
//                               print(
//                                   'No story available for ${stories![index].userName}');
//                             }
//                           },
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: 70,
//                                 height: 70,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: stories![index].hasStory!
//                                         ? Colors.red
//                                         : Colors.grey,
//                                     width: 3,
//                                   ),
//                                 ),
//                                 child: CircleAvatar(
//                                   backgroundImage: NetworkImage(
//                                       stories![index].userImage ?? ''),
//                                   child: stories![index].userImage == null
//                                       ? Icon(Icons.person)
//                                       : null,
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 stories![index].userName ?? '',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     )
//                   : Column(
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.grey,
//                               width: 3,
//                             ),
//                           ),
//                           child: CircleAvatar(
//                             backgroundImage: NetworkImage(
//                                 cubit.userModel!.profileImage ?? ''),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           cubit.userModel!.userName ?? '',
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//             ),
//             Divider(height: 1, color: Colors.grey[300]),