// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/logic/state_managments/story_cubit/story_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/presentation/screens/chat_list_screen.dart';
import 'package:instagram/presentation/widgets/post_widget.dart';
import 'package:instagram/presentation/widgets/story_widget.dart';

class NewFeedsScreen extends StatelessWidget {
  const NewFeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StoryCubit()..getStories()),
        BlocProvider(create: (_) => PostCubit()..getAllUsersPosts()),
      ],
      child: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {},
        builder: (context, state) {
          final currentUserModel = UserCubit.get(context).currentUser;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
              title: Text(
                'Instagram',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    size: 24,
                    Icons.favorite_border,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    size: 24,
                    Icons.messenger_outline,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return UsersListScreen(
                          userModel: currentUserModel!,
                        );
                      },
                    ));
                  },
                ),
                IconButton(
                  icon: Icon(
                    size: 24,
                    Icons.add_box_outlined,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: [
                // Stories Section
                BlocConsumer<StoryCubit, StoryState>(
                  listener: (context, state) {
                    if (state is StoryPickedState) {
                      onStoryPickedListener(context, state);
                    }
                  },
                  builder: (context, state) {
                    if (state is StoryLoadingState ||
                        state is StoryPickingState) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is StoryLoadedState) {
                      final stories = state.stories;
                      return BlocConsumer<UserCubit, UserState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          final userCubit = UserCubit.get(context);
                          return SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: stories
                                      .where((story) =>
                                          story.userId !=
                                          userCubit.currentUser!.uid)
                                      .length +
                                  1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  final currentUserHasStory = stories.any(
                                      (story) =>
                                          story.userId ==
                                          userCubit.currentUser!.uid);
                                  final currentUserStory = stories.where(
                                      (story) =>
                                          story.userId ==
                                          userCubit.currentUser!.uid);

                                  if (currentUserHasStory) {
                                    //current user has a story
                                    return currentUserWithStory(
                                      context: context,
                                      story: currentUserStory.single,
                                    );
                                  } else {
                                    //current user don't has a story
                                    return currentUserWithOutStory(
                                      context: context,
                                      userModel: userCubit.currentUser!,
                                    );
                                  }
                                } else {
                                  final otherStoryModels = stories
                                      .where((story) =>
                                          story.userId !=
                                          userCubit.currentUser!.uid)
                                      .toList();
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 5),
                                    child: otherStories(
                                      story: otherStoryModels[index - 1],
                                      context: context,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      );
                    } else if (state is StoryLoadErrorState) {
                      return Center(child: Text(state.error));
                    } else {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: Text('No Stories Found')),
                      );
                    }
                  },
                ),

                // Posts Section
                Expanded(
                  child: BlocBuilder<PostCubit, PostState>(
                    builder: (context, state) {
                      final currentUserId =
                          UserCubit.get(context).currentUser!.uid;
                      return buildHomeScreenPosts(
                        context: context,
                        state: state,
                        currentUserId: currentUserId!,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
