import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? fullName;
  String? email;
  String? userName;
  String? uId;
  String? website;
  String? bio;
  String? phone;
  String? gender;
  String? profileImage; 

  UserModel({
    required this.fullName,
    required this.email,
    required this.userName,
    required this.uId,
    this.website,
    this.bio,
    this.phone,
    this.gender,
    this.profileImage,
  });

  UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    fullName = json['fullName'];
    email = json['email'];
    userName = json['userName'];
    uId = json['uId'];
    website = json['website'];
    bio = json['bio'];
    phone = json['phone'];
    gender = json['gender'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'userName': userName,
      'uId': uId,
      'website': website,
      'bio': bio,
      'phone': phone,
      'gender': gender,
      'profileImage': profileImage,
    };
  }
}
