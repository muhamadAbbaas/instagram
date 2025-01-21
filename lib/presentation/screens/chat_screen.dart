// ignore_for_file: unused_local_variable, must_be_immutable, prefer_const_declarations, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/chat_cubit/chat_cubit.dart';
import 'package:instagram/logic/state_managments/chat_cubit/chat_state.dart';
import 'package:instagram/logic/model/chat/chat_model.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';

class ChatScreen extends StatelessWidget {
  UserModel userModel;
  UserModel currentUserModel;

  ChatScreen({
    super.key,
    required this.userModel,
    required this.currentUserModel,
  });

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit()
        ..getMessages(
          senderId: currentUserModel.uid!,
          receiverId: userModel.uid!,
        ),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1.0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      '${userModel.profileImage}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${userModel.userName}',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.video_call, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: [
                // Chat Messages List
                Expanded(
                  child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      final chatCubit = ChatCubit.get(context);

                      if (state is GetMessageSuccessState) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          itemCount: state.messagesList.length,
                          itemBuilder: (context, index) {
                            final ChatModel message = state.messagesList[index];
                            final isSender =
                                message.senderId == currentUserModel.uid;
                            return Align(
                              alignment: isSender
                                  ? Alignment.centerRight
                                  : Alignment
                                      .centerLeft, // Align messages accordingly
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      isSender ? Colors.blue : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  message.message!,
                                  style: TextStyle(
                                    color:
                                        isSender ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),

                // Input Field with Send Button
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Type your message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          return IconButton(
                            icon: const Icon(Icons.send, color: Colors.blue),
                            onPressed: () {
                              final messageText =
                                  _messageController.text.trim();

                              if (messageText.isNotEmpty) {
                                ChatCubit.get(context).sendMessage(
                                  senderId:
                                      UserCubit.get(context).currentUser!.uid!,
                                  receiverId: userModel.uid!,
                                  dateTime: DateTime.now().toIso8601String(),
                                  message: messageText,
                                );
                                _messageController.clear();
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
