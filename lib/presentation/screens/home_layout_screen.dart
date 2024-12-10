// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/local/cash_helper.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/presentation/screens/create_post_screen.dart';
import 'package:instagram/presentation/widgets/widgets.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is CreatePostScreenState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePostScreen(),
              ));
        }
        if(state is LogoutSuccessState){
          CacheHelper.deleteData(key: 'uId');
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: cubit.currentIndex == 0
              ? AppBar(
                  backgroundColor: Colors.white,
                  title: Text(
                    'Instagram',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        size: 24,
                        Icons.favorite_border,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        size: 24,
                        Icons.messenger_outline,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'chat_list_screen');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        size: 24,
                        Icons.add_box_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ],
                )
              : cubit.currentIndex == 4
                  ? AppBar(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      title: Text(
                        '${cubit.userModel!.userName}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    )
                  : AppBar(
                      title: Text('Instagram'),
                    ),
          endDrawer: cubit.currentIndex==4?buildDrawer(context):null,
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black26,
            currentIndex: cubit.currentIndex,
            onTap: (value) {
              cubit.changeButtomNavIndex(value);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }
}
