
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  String? userName;
  String? uId;
  String? dateTime;
  String? userImage;
  String? storyImage;

  StoryModel({
    required this.userName,
    required this.uId,
    required this.dateTime,
    required this.userImage,
    required this.storyImage,

  });

  StoryModel.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    userName = json['userName'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    userImage = json['userImage'];
    storyImage = json['storyImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'uId': uId,
      'dateTime': dateTime,
      'userImage': userImage,
      'storyImage': storyImage,
    };
  }
}
