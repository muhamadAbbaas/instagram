// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/chat/chat_model.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.model});

  UserModel model;
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
      AppCubit.get(context).getMessage(reciverId: model.uId!);
      return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
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
                      '${model.profileImage}', // Replace with user's profile picture URL
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${model.userName}',
                    style: TextStyle(color: Colors.black, fontSize: 16),
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
            body:  Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: cubit.messagesList.length,
                        itemBuilder: (context, index) {
                        
                          return buildMessageBubble(
                            chatModel: cubit.messagesList[index],
                            isSender: true,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 3);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: .5,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        clipBehavior:Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.camera_alt_outlined,
                                  color: Colors.black54),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  hintText: "Message...",
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
                                  border: InputBorder.none,
                                ),
                               
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.blue),
                              onPressed: () {
                                AppCubit.get(context).sendMessage(
                                  reciverId: model.uId!,
                                  dateTime: DateTime.now().toString(),
                                  message: messageController.text,
                                );
                                messageController.clear();
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
          );
        },
      );
    });
  }

  Widget buildMessageBubble({
    required bool isSender,
    required ChatModel chatModel,
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isSender ? Radius.circular(12) : Radius.zero,
            bottomRight: isSender ? Radius.zero : Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              chatModel.message!,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              chatModel.dateTime!,
              style: TextStyle(
                color: isSender ? Colors.white60 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
