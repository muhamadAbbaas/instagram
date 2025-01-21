// ignore_for_file: unused_import, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_null_comparison, unused_local_variable, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/constants/themes.dart';
import 'package:instagram/logic/state_managments/story_cubit/story_cubit.dart';
import 'package:instagram/logic/state_managments/theme_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/presentation/screens/chat_list_screen.dart';
import 'package:instagram/presentation/screens/chat_screen.dart';
import 'package:instagram/presentation/screens/login_screen.dart';
import 'package:instagram/presentation/screens/signup_screen.dart';
import 'package:instagram/constants/consatant.dart';
import 'package:instagram/data/local/cash_helper.dart';
import 'package:instagram/presentation/screens/profile.dart';
import 'package:instagram/presentation/screens/home_layout_screen.dart';
import 'package:instagram/presentation/screens/edit_profie.dart';
import 'package:instagram/presentation/screens/other_user_profile.dart';
import 'package:instagram/presentation/widgets/app_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://rspdwskgyhttgunbbwsf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJzcGR3c2tneWh0dGd1bmJid3NmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI1NzgxOTQsImV4cCI6MjA0ODE1NDE5NH0.TrVZJTQDaXxjt81nQRlf3U4fiXFKU10sX_cqQG55_B0',
  );

  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid; 

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit()
            ..checkLoginStatus()
            ..getUserData(uid!),
        ),
        BlocProvider(
          create: (context) => PostCubit(),
        ),
        BlocProvider(
          create: (context) => StoryCubit(),
        ),
        BlocProvider(
          create: (context) => AppCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: AppEntry(),
            routes: {
              'sign_up': (context) => SignUpScreen(),
              'login': (context) => LoginScreen(),
              'home_page': (context) => HomeLayoutScreen(),
              'profile': (context) => ProfileScreen(),
              'profile_editing': (context) => EditProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
