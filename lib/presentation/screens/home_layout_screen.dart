import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final appCubit = context.read<AppCubit>(); 

        return Scaffold(
          body: Stack(
            children: [
              appCubit.mainScreens[appCubit.currentIndex], 
              if (appCubit.currentOverlayScreen != null)
                appCubit.currentOverlayScreen!,
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            backgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            currentIndex: appCubit.currentIndex,
            onTap: appCubit.changeBottomNavIndex,
            items: [
              const BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.squarePlus),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.heart),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    final userCubit = UserCubit.get(context);
                    final profileImage = userCubit.currentUser?.profileImage;
                    return CircleAvatar(
                      radius: 12,
                      backgroundImage: profileImage != null
                          ? NetworkImage(profileImage)
                          : const AssetImage('assets/images/download.jpg')
                              as ImageProvider,
                      backgroundColor: Colors.grey.shade300,
                    );
                  },
                ),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }
}
