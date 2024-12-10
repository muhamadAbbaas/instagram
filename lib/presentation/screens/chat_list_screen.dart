// ignore_for_file: avoid_print, prefer_const_constructors, prefer_is_empty

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/presentation/screens/chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1.0,
            title: const Text(
              "Chats",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: cubit.usersList.length > 0,
            builder: (context) {
              return ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: cubit.usersList.length,
                separatorBuilder: (context, index) {
                  return myDivider();
                },
                itemBuilder: (context, index) {
                  return buildChatTile(
                    model: cubit.usersList[index],
                    lastMessage: "Last message from User $index",
                    timestamp: "10:${index}0 AM",
                    isRead: index % 2 == 0,
                    context: context, 
                  );
                },
              );
            },
            fallback: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildChatTile({
    required UserModel model,
    required String lastMessage,
    required String timestamp,
    required bool isRead,
    required BuildContext context,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(model.profileImage.toString()),
      ),
      title: Text(
        model.userName!,
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        lastMessage,
        style: TextStyle(
          color: isRead ? Colors.grey : Colors.black,
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        timestamp,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(model: model),));  
      },
    );
  }

  Widget myDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        color: Colors.grey[200],
        width: double.infinity,
        height: 1,
      ),
    );
  }
}
