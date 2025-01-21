// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, sort_child_properties_last, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/presentation/screens/home_layout_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              final userCubit = BlocProvider.of<UserCubit>(context);
              userCubit.getUserData(userCubit.auth.currentUser?.uid ?? "");
              return HomeLayoutScreen();
            }),
          );
        }
        if (state is LoginErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
          print(state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 50.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Instagram',
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        label: Text('Email Address'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter your email';
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        label: Text('Password'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter your password';
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        fixedSize: Size(400, 50),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          UserCubit.get(context).login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'sign_up');
                          },
                          child: Text(
                            'Register Now',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
