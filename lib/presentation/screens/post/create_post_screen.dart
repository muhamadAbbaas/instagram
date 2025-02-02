// ignore_for_file: must_be_immutable, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/presentation/widgets/profile_widgets.dart';
import 'package:video_player/video_player.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  final TextEditingController captionController = TextEditingController();
  VideoPlayerController? _videoController;
  String? postType;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
       if (state is PostUplodingState) {
      showLoadingDialog(context,"Uploading your Post...");
    }
    if (state is PostUplodedState) {
      hideDialog(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Your Post Uploaded Successfully!",
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
    if (state is PostUplodeErrorState) {
      hideDialog(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to upload your post.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
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
        var cubit = PostCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            title: Text(
              'New Post',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await cubit.pickMedia();
                        // Initialize video player if the picked media is a video
                        if (cubit.postMedia != null &&
                            cubit.postMedia!.path.contains('VID')) {
                          _videoController =
                              VideoPlayerController.file(cubit.postMedia!)
                                ..initialize().then((_) {
                                  postType = 'vedio';
                                  _videoController!
                                      .play(); 
                                });
                        }
                        postType = 'image';
                      },
                      child: cubit.postMedia == null
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
                          : cubit.postMedia!.path.contains('VID')
                              ? _videoController != null &&
                                      _videoController!.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _videoController!.value.aspectRatio,
                                      child: VideoPlayer(_videoController!),
                                    )
                                  : Center(child: CircularProgressIndicator())
                              : Image.file(
                                  cubit.postMedia!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    if (cubit.postMedia != null)
                      IconButton(
                        onPressed: () {
                          cubit.removeMedia();
                          _videoController?.dispose();
                          _videoController = null;
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
                    print('Location clicked');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Tag People'),
                  onTap: () {
                    print('Tag People clicked');
                  },
                ),
                TextButton(
                  onPressed: () {
                    final currentUser = UserCubit.get(context).currentUser;
                    cubit.uploadPostMedia(
                      captionController.text,
                      cubit.postMedia!,
                      postType!,
                      currentUser!.uid!,
                    );
                  },
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue, width: 2),
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), 
                      ),
                      minimumSize: const Size(100, 40)),
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
