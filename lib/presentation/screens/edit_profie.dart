// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';

class EditProfileScreen extends StatelessWidget {
  final UserModel? userModel;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController webSiteController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  EditProfileScreen({super.key, this.userModel});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is ProfileImageUploadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Uploading your Profile Image...",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
        }
        if (state is ProfileImageUploadErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Profile Image Uploaded Successfully...",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        fullNameController.text = cubit.currentUser!.fullName!;
        userNameController.text = cubit.currentUser!.userName!;
        emailController.text = cubit.currentUser!.email!;
        webSiteController.text = cubit.currentUser!.website ?? '';
        genderController.text = cubit.currentUser!.gender ?? '';
        bioController.text = cubit.currentUser!.bio ?? '';
        phoneController.text = cubit.currentUser!.phone ?? '';
        return Scaffold(
          appBar: AppBar(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {}, //todo
                  ),
                ),
              ],
            ),
            title: const Center(
              child: Text(
                'Edit profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  cubit.updateUserData(
                    updatedFields: {
                      'userName': userNameController.text,
                      'fullName': fullNameController.text,
                      'bio': bioController.text,
                      'email': emailController.text,
                      'website': webSiteController.text,
                      'phone': phoneController.text,
                      'gender': genderController.text,
                    },
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      height: 98.74,
                      width: 98.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: cubit.profileImage == null
                              ? NetworkImage(cubit.currentUser!.profileImage!)
                              : FileImage(cubit.profileImage!),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            cubit.pickProfileImage();
                          },
                          child: Text('Change profile photo'),
                        ),
                        if (cubit.profileImage != null)
                          TextButton(
                            onPressed: () {
                              cubit.uploadProfileImage(
                                uid: cubit.currentUser!.uid!,
                              );
                            },
                            child: Text('Upload profile photo'),
                          ),
                      ],
                    ),
                    Container(
                      width: 375,
                      height: 204,
                      child: Column(
                        children: [
                          Container(
                            width: 375,
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  width: 65,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 25),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        userModel!.fullName = value;
                                      },
                                      controller: fullNameController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        label: Text('name'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 375,
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  width: 65,
                                  child: Text(
                                    'Username',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 25),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        userModel!.userName = value;
                                      },
                                      controller: userNameController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        label: Text('username'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 375,
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  width: 65,
                                  child: Text(
                                    'Website',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 25),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        userModel!.website = value;
                                      },
                                      controller: webSiteController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        label: Text('website'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 375,
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  width: 65,
                                  child: Text(
                                    'Bio',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 25),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        userModel!.bio = value;
                                      },
                                      controller: bioController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        label: Text('bio'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 49,
                      width: 375,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Switch to profissional Account',
                            style: TextStyle(
                              color: Colors.blue[500],
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 390,
                      height: 200.09,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 15,
                            child: Text(
                              'Private Infirmation',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              width: 375,
                              height: 50,
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    child: Text(
                                      'Email',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 25),
                                      child: TextField(
                                        onSubmitted: (value) {
                                          userModel!.email = value;
                                        },
                                        controller: emailController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          label: Text('email'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 375,
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  child: Text(
                                    'Phone',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 25),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        userModel!.phone = value;
                                      },
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        label: Text('phone'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 375,
                            height: 50,
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 25),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        userModel!.gender = value;
                                      },
                                      controller: genderController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        label: Text('gender'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
