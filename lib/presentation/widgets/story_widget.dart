// ignore_for_file: use_super_parameters, unused_element, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/story/story_model.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/story_cubit/story_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/presentation/screens/create_story_screen.dart';
import 'package:instagram/presentation/screens/view_story_screen.dart';

Widget currentUserWithStory({
  required StoryModel story,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 5),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ViewStoryScreen(storyModel: story);
            },
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.pinkAccent,
                      Colors.orangeAccent,
                      Colors.yellowAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(story.userImage),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text("Your Story"),
        ],
      ),
    ),
  );
}

Widget currentUserWithOutStory({
  required UserModel userModel,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, right: 5),
    child: GestureDetector(
      onTap: () => StoryCubit.get(context).pickStoryImage(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(
                  userModel.profileImage!,
                ),
              ),
              const CircleAvatar(
                radius: 10,
                foregroundColor: Colors.white,
                child: Icon(
                  Icons.add_circle,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text("Your Story"),
        ],
      ),
    ),
  );
}

Widget otherStories({
  required StoryModel story,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      StoryCubit.get(context).markStoryAsWatched(story.storyId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ViewStoryScreen(storyModel: story);
          },
        ),
      );
    },
    child: Container(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              story.isWatched == true
                  ? Container(
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey,
                            Colors.white,
                            Colors.grey,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    )
                  : Container(
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.pinkAccent,
                            Colors.orangeAccent,
                            Colors.yellowAccent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(story.userImage),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            story.userName,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

void onStoryPickedListener(BuildContext context, StoryPickedState state) {
  final userCubit = BlocProvider.of<UserCubit>(context);
  final user = userCubit.currentUser;

  if (user != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateStoryScreen(
          selectedImage: state.image,
          userModel: user,
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User not found')),
    );
  }
}
