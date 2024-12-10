// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';

// ignore: must_be_immutable
class ShareStoryScreen extends StatelessWidget {
  ShareStoryScreen({super.key, required this.selectedImage});
  final TextEditingController _captionController = TextEditingController();
  File selectedImage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is UploadStoryImageLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Uploading your Story...",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
        }
        if (state is CreateStorySuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Your story Uploaded Successfully...",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Share Story",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  cubit.uploadStoryImage(
                    dateTime: DateTime.now().toString(),
                    storyImage: cubit.storyImage,
                  );
                  Navigator.pushReplacementNamed(context, 'home_page');
                },
                child: Text(
                  "Share",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Media Display Area
              GestureDetector(
                onTap: () {},
                child: Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[900],
                    child: Image.file(selectedImage, fit: BoxFit.cover)),
              ),

              // Caption Input
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _captionController,
                  maxLines: 2,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Write a caption...",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Sticker and Additional Features Section (Optional)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.emoji_emotions, color: Colors.grey),
                      onPressed: () {
                        print("Add stickers");
                      },
                    ),
                    Text("Add Stickers", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
