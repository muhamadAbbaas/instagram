// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/presentation/widgets/chat_widget.dart';

class UsersListScreen extends StatelessWidget {
  UserModel currentUserModel;
  UsersListScreen({super.key, required this.currentUserModel});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UserCubit>(context).getAllUsers();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: const Text(
          "Chats",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetAllUsersLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetAllUsersLoadedState) {
            final users = state.users
                .where((user) => user.uid != currentUserModel.uid)
                .toList();
            return buildUsersList(
              context: context,
              users: users,
              currentUserModel: currentUserModel,
            );
          }
          return const Center(
            child: Text('No users found!'),
          );
        },
      ),
    );
  }
}
