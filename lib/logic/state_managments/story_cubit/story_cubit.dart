// ignore_for_file: unused_field, avoid_print, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/logic/model/story/story_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit() : super(StoryInitial());

  static StoryCubit get(context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? storyImage;
  ImagePicker picker = ImagePicker();

  Future<void> pickStoryImage() async {
    emit(StoryPickingState());
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        storyImage = File(pickedFile.path);
        emit(StoryPickedState(image: storyImage!));
      } else {
        emit(StoryPickErrorState());
      }
    } catch (e) {
      emit(StoryPickErrorState());
    }
  }

  void createNewStory({
    required String userId,
    required String userName,
    required String userImage,
    required String storyImage,
  }) async {
    StoryModel story = StoryModel(
      storyId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      userImage: userImage,
      storyImage: storyImage,
      timestamp: DateTime.now(),
      isWatched: false,
    );
    emit(StoryCreatingState());
    try {
      await _firestore
          .collection('stories')
          .doc(story.storyId)
          .set(story.toJson());
      emit(StoryCreatedState(story));
      getStories();
    } catch (e) {
      emit(StoryCreateErrorState(e.toString()));
    }
  }

  void uploadStoryImage({
    required String userId,
    required String userName,
    required String userImage,
    required File storyImage,
  }) async {
    emit(StoryUploadingState());

    final fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final supabase = Supabase.instance.client;
    final path = 'uploads/$fileName';

    try {
      // Upload the image to Supabase storage
      await supabase.storage.from('story_images').upload(path, storyImage);
      final publicUrl =
          supabase.storage.from('story_images').getPublicUrl(path);

      // Create a new story
      createNewStory(
        userId: userId,
        userName: userName,
        userImage: userImage,
        storyImage: publicUrl,
      );
    } catch (e) {
      emit(StoryUploadErrorState("Failed to upload story image: $e"));
    }
  }

  Stream<List<Map<String, dynamic>>> getActiveStories() {
    final now = DateTime.now();
    final cutoffTime = now.subtract(const Duration(hours: 24));

    return FirebaseFirestore.instance
        .collection('stories')
        .where('timestamp', isGreaterThan: Timestamp.fromDate(cutoffTime))
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> deleteExpiredStories() async {
    final now = DateTime.now();
    final cutoffTime = now.subtract(const Duration(hours: 24));

    final snapshot = await FirebaseFirestore.instance
        .collection('stories')
        .where('timestamp', isLessThan: Timestamp.fromDate(cutoffTime))
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  void getStories() {
    emit(StoryLoadingState());
    try {
      FirebaseFirestore.instance.collection('stories').snapshots().listen(
        (snapshot) {
          final stories = snapshot.docs
              .map((doc) => StoryModel.fromJson(doc.data()))
              .toList();
          if (stories.isEmpty) {
            emit(StoryLoadedState([]));
          } else {
            emit(StoryLoadedState(stories));
          }
        },
      );
    } catch (e) {
      emit(StoryLoadErrorState("An unexpected error occurred: $e"));
    }
  }

  Future<void> markStoryAsWatched(String storyId) async {
    try {
      await _firestore.collection('stories').doc(storyId).update({
        'isWatched': true,
      });
      emit(StoryUpdatedState());
      getStories();
    } catch (e) {
      emit(StoryUpdateErrorState("Failed to update story: $e"));
    }
  }
}
