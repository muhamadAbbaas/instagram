import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final appCubit = AppCubit.get(context);

        return Scaffold(
          body: Stack(
            children: [
              appCubit.mainScreens[appCubit.currentIndex], // Main tab content
              if (appCubit.currentOverlayScreen != null)
                appCubit.currentOverlayScreen!, // Overlay screen
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
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: ''),
            ],
          ),
        );
      },
    );
  }
}
