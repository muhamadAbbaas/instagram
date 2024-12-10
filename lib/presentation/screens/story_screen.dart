// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/story/story_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';

class StoryScreen extends StatelessWidget {
  StoryScreen({super.key, required this.storyModel});

  StoryModel storyModel;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                // Display the selected story image
                child: Image.network(
                  storyModel.storyImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // Top Bar (Back Button + User Info)
              SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        storyModel.userImage!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      storyModel.userName!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
