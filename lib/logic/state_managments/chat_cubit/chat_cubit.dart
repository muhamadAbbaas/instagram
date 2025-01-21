// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/chat/chat_model.dart';
import 'package:instagram/logic/state_managments/chat_cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendMessage({
    required String senderId,
    required String receiverId,
    required String dateTime,
    required String message,
  }) async {
    final chatModel = ChatModel(
      senderId: senderId,
      reciverId: receiverId,
      dateTime: dateTime,
      message: message,
    );

    try {
      // Save message for sender
      await _saveMessage(
        senderId: senderId,
        receiverId: receiverId,
        chatModel: chatModel,
      );

      // Save message for receiver
      await _saveMessage(
        senderId: receiverId,
        receiverId: senderId,
        chatModel: chatModel,
      );

      emit(SendMessageSuccessState());
      getMessages(
        receiverId: receiverId,
        senderId: senderId,
      );
    } catch (error) {
      emit(SendMessageErrorState());
    }
  }

  /// Helper method to save a message to Firestore.
  Future<void> _saveMessage({
    required String senderId,
    required String receiverId,
    required ChatModel chatModel,
  }) {
    return _firestore
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(chatModel.toMap());
  }

  void getMessages({
    required String senderId,
    required String receiverId,
  }) {
    _firestore
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      final messagesList =
          event.docs.map((doc) => ChatModel.fromJson(doc)).toList();
      emit(GetMessageSuccessState(messagesList: messagesList));
    });
  }

   Future<ChatModel?> getLastMessage({
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(senderId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .orderBy('dateTime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return ChatModel.fromJson(querySnapshot.docs.first);
      } else {
        return null; // No messages found
      }
    } catch (error) {
      print("Error fetching last message: $error");
      return null;
    }
  }
}
