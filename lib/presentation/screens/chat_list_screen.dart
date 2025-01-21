// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/chat_cubit/chat_cubit.dart';
import 'package:instagram/logic/state_managments/chat_cubit/chat_state.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/presentation/screens/chat_screen.dart';

class UsersListScreen extends StatelessWidget {
  UserModel userModel;
  UsersListScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
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
      body: BlocProvider(
        create: (context) => UserCubit()..getAllUsers(),
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetAllUsersLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetAllUsersLoadedState) {
              final users = state.users
                  .where((user) => user.uid != userModel.uid)
                  .toList();
              return buildUsersList(context, users);
            }
            return const Center(
              child: Text('No users found!'),
            );
          },
        ),
      ),
    );
  }

  Widget buildUsersList(BuildContext context, List<UserModel> users) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (context, index) {
        return myDivider();
      },
      itemBuilder: (context, index) {
        return buildChatTile(
          context: context,
          model: users[index],
        );
      },
    );
  }

  Widget buildChatTile({
    required BuildContext context,
    required UserModel model,
  }) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(model.profileImage.toString()),
            ),
            title: Text(
              model.userName!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: FutureBuilder(
              future: ChatCubit.get(context).getLastMessage(
                senderId: userModel.uid!,
                receiverId: model.uid!,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "Loading...",
                    style: TextStyle(color: Colors.grey),
                  );
                } else if (snapshot.hasData) {
                  final lastMessage =
                      snapshot.data?.message ?? "No messages yet";
                  return Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  );
                } else {
                  return const Text(
                    "No messages yet",
                    style: TextStyle(color: Colors.grey),
                  );
                }
              },
            ),
            trailing: FutureBuilder(
              future: ChatCubit.get(context).getLastMessage(
                senderId: userModel.uid!,
                receiverId: model.uid!,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("");
                } else if (snapshot.hasData) {
                  final timestamp = snapshot.data?.dateTime ?? "";
                  return Text(
                    formatTimestamp(
                        timestamp), // A function to format timestamps
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  );
                } else {
                  return const Text("");
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    userModel: model,
                    currentUserModel: userModel,
                  ),
                ),
              );
            },
          );
        },
      ),
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

  String formatTimestamp(String dateTime) {
    // Convert ISO8601 string to DateTime and format it
    try {
      final date = DateTime.parse(dateTime);
      return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return "";
    }
  }
}
