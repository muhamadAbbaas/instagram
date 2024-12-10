// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/auth_cubit/auth_cubit.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccessState) {
            Navigator.pushNamed(context, 'login');
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
                          label: Text('Email'),
                          border: OutlineInputBorder(borderRadius:BorderRadius.circular(8)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Email';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          label: Text('Password'),
                          border: OutlineInputBorder(borderRadius:BorderRadius.circular(8)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Password';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          label: Text('Full Name'),
                          border: OutlineInputBorder(borderRadius:BorderRadius.circular(8)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Full Name';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          label: Text('Username'),
                         border: OutlineInputBorder(borderRadius:BorderRadius.circular(8)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your Username';
                          }
                        },
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
                            AuthCubit.get(context).userRegister(
                              email: emailController.text,
                              fullName: fullNameController.text,
                              password: passwordController.text,
                              userName: userNameController.text,

                            );
                          }
                        },
                        child: Text('Register'),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(foregroundColor:Colors.black ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, 'login');
                            },
                            child: Text('Login'),
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
