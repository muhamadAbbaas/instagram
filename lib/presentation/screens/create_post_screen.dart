// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  final TextEditingController captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is UploadPostImageLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Waiting for uploading your post...",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
        }
        if (state is CreatePostSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Post Uploaded Successfully...",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
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
        var dateTime = DateTime.now();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            title: Text(
              'New Post',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    GestureDetector(
                      onTap: cubit.pickPostImage,
                      child: cubit.postImage == null
                          ? Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.grey[700],
                                ),
                              ),
                            )
                          : Image.file(
                              cubit.postImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    IconButton(
                      onPressed: () {
                        cubit.removeImage();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: captionController,
                    decoration: InputDecoration(
                      hintText: 'Write a caption...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Add Location'),
                  onTap: () {
                    // Navigate to location picker (optional)
                    print('Location clicked');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Tag People'),
                  onTap: () {
                    // Navigate to tagging screen (optional)
                    print('Tag People clicked');
                  },
                ),
                TextButton(
                  onPressed: () {
                    cubit.uploadPostImage(
                      dateTime.toString(),
                      captionController.text,
                      cubit.postImage!,
                    );
                  },
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Text color
                      side: const BorderSide(
                          color: Colors.blue, width: 2), // Border
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                      minimumSize: const Size(100, 30)),
                  child: Text('Share'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
