import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String storyId;
  final String userId;
  final String userName;
  final String userImage;
  final String storyImage;
  final DateTime timestamp;
  final bool isWatched;

  StoryModel({
    required this.storyId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.storyImage,
    required this.timestamp,
    required this.isWatched,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      storyId: json['storyId'],
      userId: json['userId'],
      userName: json['userName'],
      userImage: json['userImage'],
      storyImage: json['storyImage'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      isWatched: json['isWatched'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'storyImage': storyImage,
      'timestamp': timestamp,
      'isWatched': isWatched,
    };
  }
}
