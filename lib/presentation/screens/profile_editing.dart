// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/state_managments/app_cubit/app_cubit.dart';

class ProfileEditing extends StatelessWidget {
  const ProfileEditing({super.key});

  @override
  Widget build(BuildContext context) {
    late TextEditingController fullNameController = TextEditingController();
    late TextEditingController userNameController = TextEditingController();
    late TextEditingController webSiteController = TextEditingController();
    late TextEditingController bioController = TextEditingController();
    late TextEditingController emailController = TextEditingController();
    late TextEditingController phoneController = TextEditingController();
    late TextEditingController genderController = TextEditingController();
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is UploadProfileImageLoadingState) {
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
        if (state is UploadProfileImageSuccessState) {
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
        var cubit = AppCubit.get(context);
        fullNameController.text = cubit.userModel!.fullName!;
        userNameController.text = cubit.userModel!.userName!;
        emailController.text = cubit.userModel!.email!;
        bioController.text = cubit.userModel!.bio??'';
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
                    userName: userNameController.text,
                    bio: bioController.text,
                    email: emailController.text,
                    fullName: fullNameController.text,
                    gender: genderController.text,
                    phone: phoneController.text,
                    website: webSiteController.text,
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
                              ? AssetImage('assets/images/download.jpg')
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
                              cubit.uploadProfileImage();
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
                                        cubit.userModel!.fullName = value;
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
                                        cubit.userModel!.userName = value;
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
                                        cubit.userModel!.website = value;
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
                                        cubit.userModel!.bio = value;
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
                                          cubit.userModel!.email = value;
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
                                        cubit.userModel!.phone = value;
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
                                        cubit.userModel!.gender = value;
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
