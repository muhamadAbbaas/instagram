import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/chat_cubit/chat_cubit.dart';
import 'package:instagram/logic/state_managments/chat_cubit/chat_state.dart';
import 'package:instagram/presentation/screens/chat/chat_screen.dart';

Widget buildUsersList({
  required BuildContext context,
  required List<UserModel> users,
  required UserModel currentUserModel,
}) {
  return ListView.separated(
    physics: const BouncingScrollPhysics(),
    itemCount: users.length,
    separatorBuilder: (context, index) {
      return myDivider();
    },
    itemBuilder: (context, index) {
      return buildChatTile(
        context: context,
        senderUserModel: currentUserModel,
        reciverUserModel: users[index],
      );
    },
  );
}

Widget buildChatTile({
  required BuildContext context,
  required UserModel senderUserModel,
  required UserModel reciverUserModel,
}) {
  return BlocBuilder<ChatCubit, ChatState>(
    builder: (context, state) {
      return ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage:
              NetworkImage(reciverUserModel.profileImage.toString()),
        ),
        title: Text(
          reciverUserModel.userName!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: FutureBuilder(
          future: context.read<ChatCubit>().getLastMessage(
                senderId: senderUserModel.uid!,
                receiverId: reciverUserModel.uid!,
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Loading...",
                style: TextStyle(color: Colors.grey),
              );
            } else if (snapshot.hasData) {
              final lastMessage = snapshot.data?.message ?? "No messages yet";
              return Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
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
          future: context.read<ChatCubit>().getLastMessage(
                senderId: senderUserModel.uid!,
                receiverId: reciverUserModel.uid!,
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("");
            } else if (snapshot.hasData) {
              final timestamp = snapshot.data?.dateTime ?? "";
              return Text(
                formatTimestamp(timestamp),
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
                userModel: reciverUserModel,
                currentUserModel: senderUserModel,
              ),
            ),
          );
        },
      );
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

String formatTimestamp(String dateTime) {
  try {
    final date = DateTime.parse(dateTime);
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  } catch (_) {
    return "";
  }
}
