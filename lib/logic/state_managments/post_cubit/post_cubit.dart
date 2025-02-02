// ignore_for_file: avoid_print, unnecessary_null_comparison, unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/post/post_model.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  static PostCubit get(context) => BlocProvider.of(context);

  File? postMedia;
  ImagePicker picker = ImagePicker();
  final Map<String, List<PostModel>> userPosts = {};

  /// Function to pick media (image or video) from the gallery
  Future<void> pickMedia() async {
    emit(PostPickingState());
    try {
      final pickedFile = await picker.pickMedia();
      if (pickedFile != null) {
        postMedia = File(pickedFile.path);
        print('post media is ${postMedia}');

        //check post type
        if (postMedia!.path.contains('IMG')) {
          print("Picked an image");
        } else if (postMedia!.path.contains('VID')) {
          print("Picked a video");
        } else {
          print("Unknown media type");
        }
        emit(PostPickedState());
      } else {
        emit(PostPickedErrorState());
      }
    } catch (e) {
      emit(PostPickedErrorState());
    }
  }

  /// Function to remove selected media
  void removeMedia() {
    postMedia = null;
    emit(RemoveImageState());
  }

  /// Function to create a new post
  void createPost({
    required String caption,
    required String postMediaUrl,
    required String postType,
    required String userId,
  }) async {
    emit(PostCreatingState());
    try {
      final postId = FirebaseFirestore.instance.collection('posts').doc().id;
      PostModel post = PostModel(
        postId: postId,
        uid: userId,
        caption: caption,
        postImage: postMediaUrl,
        postType: postType,
        timestamp: DateTime.now(),
        likes: [],
        likeCount: 0,
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(post.toJson());
      emit(PostCreatedState(post));
    } catch (e) {
      emit(PostLoadedErrorState(e.toString()));
    }
  }

  /// Function to upload media to Supabase
  Future<void> uploadPostMedia(
    String caption,
    File postMedia,
    String postType,
    String userId,
  ) async {
    emit(PostUplodingState());
    try {
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final supabase = Supabase.instance.client;
      final path = 'uploads/$fileName';

      // Upload the file
      await supabase.storage.from('post_media').upload(path, postMedia);
      final publicUrl = supabase.storage.from('post_media').getPublicUrl(path);

      // Create post after successful upload
      createPost(
        caption: caption,
        postMediaUrl: publicUrl,
        postType: postType,
        userId: userId,
      );
      emit(PostUplodedState());
    } catch (e) {
      emit(PostUplodeErrorState());
    }
  }

  void toggleLike(PostModel post, String userId) async {
    final postRef =
        FirebaseFirestore.instance.collection('posts').doc(post.postId);
    final isLiked = post.likes.contains(userId);

    try {
      if (isLiked) {
        await _unlikePost(postRef, userId);
        // Update local state
        final updatedLikes = List<String>.from(post.likes)..remove(userId);
        final updatedPost = post.copyWith(likes: updatedLikes);
        emit(PostLikedState(postModel: updatedPost));
      } else {
        await _likePost(postRef, userId);
        // Update local state
        final updatedLikes = List<String>.from(post.likes)..add(userId);
        final updatedPost = post.copyWith(likes: updatedLikes);
        emit(PostLikedState(postModel: updatedPost));
      }
    } catch (e) {
      emit(PostLikeErrorState(e.toString()));
    }
  }

// Method to handle liking the post
  Future<void> _likePost(DocumentReference postRef, String userId) async {
    await postRef.update({
      'likes': FieldValue.arrayUnion([userId]),
      'likeCount': FieldValue.increment(1),
    });
    getAllUsersPosts();
  }

// Method to handle unliking the post
  Future<void> _unlikePost(DocumentReference postRef, String userId) async {
    await postRef.update({
      'likes': FieldValue.arrayRemove([userId]),
      'likeCount': FieldValue.increment(-1),
    });
    getAllUsersPosts();
  }

  void getAllUsersPosts() async {
    emit(PostLoadingState());
    try {
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final postSnapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      final users = userSnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();

      final posts = postSnapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data());
      }).toList();

      // Combine posts with user data
      final postsWithUserData = posts.map((post) {
        final user = users.firstWhere((user) => user.uid == post.uid);
        return {
          'post': post,
          'user': user,
        };
      }).toList();

      emit(AllPostsWithUserLoadedState(postsWithUserData));
    } catch (e) {
      emit(PostLoadedErrorState(e.toString()));
    }
  }

  void getSpecificUserData(String uid) async {
    emit(UserDataLoadingState());
    try {
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userSnapshot.exists || userSnapshot.data() == null) {
        emit(PostLoadedErrorState("User not found"));
        return;
      }
      final user = UserModel.fromJson(userSnapshot.data()!);
      final postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      final posts = postsSnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();

      emit(UserPostsWithDataLoadedState(user: user, posts: posts));
    } catch (error, stackTrace) {
      print("Error fetching user data: $error");
      print("StackTrace: $stackTrace");
      emit(PostLoadedErrorState(error.toString()));
    }
  }

  Future<int> getPostsCount(String userId) async {
    try {
      final posts = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: userId)
          .get();
      return posts.docs.length;
    } catch (e) {
      return 0;
    }
  }
}
