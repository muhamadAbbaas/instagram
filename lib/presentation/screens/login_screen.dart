// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable, sort_child_properties_last, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/auth_cubit/auth_cubit.dart';
import 'package:instagram/data/local/cash_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessState ){
          CacheHelper.setData(
            key: 'uId',
            value: state.uId,
          ).then((value) {
            Navigator.pushReplacementNamed(context, 'home_page');
          });
        }
        if (state is LoginErrorState) {
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
                          AuthCubit.get(context).userLogin(
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
