
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? userName;
  String? fullName;
  String? uId;
  String? caption;
  String? dateTime;
  String? userImage;
  String? postImage;
  bool? isLiked;
  int? likeNum;

  PostModel({
    required this.userName,
    required this.fullName,
    required this.uId,
    required this.caption,
    required this.dateTime,
    required this.userImage,
    required this.postImage,
    this.isLiked,
    this.likeNum,
  });

  PostModel.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    userName = json['userName'];
    fullName = json['fullName'];
    uId = json['uId'];
    caption = json['caption'];
    dateTime = json['dateTime'];
    userImage = json['userImage'];
    postImage = json['postImage'];
    isLiked = json['isLiked'];
    likeNum = json['likeNum'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'fullName': fullName,
      'uId': uId,
      'caption': caption,
      'dateTime': dateTime,
      'userImage': userImage,
      'postImage': postImage,
      'isLiked': isLiked,
      'likeNum': likeNum,
    };
  }
}
