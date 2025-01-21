// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? senderId;
  String? reciverId;
  String? dateTime;
  String? message;

  ChatModel({
    this.senderId,
    this.reciverId,
    this.dateTime,
    this.message,
  });

  factory ChatModel.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    return ChatModel(
      senderId: json['senderId'],
      reciverId: json['reciverId'],
      dateTime: json['dateTime'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'dateTime': dateTime,
      'message': message,
    };
  }
}
