// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable, unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/post_cubit/post_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_cubit.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/presentation/widgets/profile_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? userModel;

  const EditProfileScreen({super.key, this.userModel});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _userNameController;
  late final TextEditingController _webSiteController;
  late final TextEditingController _bioController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _userNameController = TextEditingController();
    _webSiteController = TextEditingController();
    _bioController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _genderController = TextEditingController();

    _initializeControllers();
  }

  void _initializeControllers() {
    final cubit = context.read<UserCubit>(); 
    _fullNameController.text =
        cubit.currentUser?.fullName ?? ''; 
    _userNameController.text = cubit.currentUser?.userName ?? '';
    _emailController.text = cubit.currentUser?.email ?? '';
    _webSiteController.text = cubit.currentUser?.website ?? '';
    _genderController.text = cubit.currentUser?.gender ?? '';
    _bioController.text = cubit.currentUser?.bio ?? '';
    _phoneController.text = cubit.currentUser?.phone ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _webSiteController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is ProfileImageUploadingState) {
          showLoadingDialog(context, "Uploading your Profile Image...");
        }
        if (state is ProfileImageUploadedState) {
          hideDialog(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Profile Image Uploaded Successfully!",
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
        if (state is ProfileImageUploadErrorState) {
          hideDialog(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to upload profile image.",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
        }
        if (state is UserDataUpdatedState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit =UserCubit.get(context);
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            title: const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 48.0),
                child: Text(
                  'Edit profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            actions: [
              BlocBuilder<PostCubit, PostState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: () {
                      cubit.updateUserData(
                        updatedFields: {
                          'userName': _userNameController.text,
                          'fullName': _fullNameController.text,
                          'bio': _bioController.text,
                          'email': _emailController.text,
                          'website': _webSiteController.text,
                          'phone': _phoneController.text,
                          'gender': _genderController.text,
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
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
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          height: 98.74,
                          width: 98.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: cubit.profileImage == null
                                  ? NetworkImage(
                                      cubit.currentUser!.profileImage!,
                                    )
                                  : FileImage(cubit.profileImage!),
                            ),
                          ),
                        ),
                        if (cubit.profileImage != null)
                          IconButton(
                            onPressed: () {
                              cubit.removeMedia();
                            },
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.black54,
                            ),
                          ),
                      ],
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
                          style: TextButton.styleFrom(
                            minimumSize: Size(300, 40),
                          ),
                          child: Text('Change profile photo'),
                        ),
                        if (cubit.profileImage != null)
                          TextButton(
                            onPressed: () {
                              cubit.uploadProfileImage(
                                uid: cubit.currentUser!.uid!,
                              );
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(300, 40),
                            ),
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
                                        widget.userModel!.fullName = value;
                                      },
                                      controller: _fullNameController,
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
                                      start: 25,
                                    ),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        widget.userModel!.userName = value;
                                      },
                                      controller: _userNameController,
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
                                      start: 25,
                                    ),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        widget.userModel!.website = value;
                                      },
                                      controller: _webSiteController,
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
                                      start: 25,
                                    ),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        widget.userModel!.bio = value;
                                      },
                                      controller: _bioController,
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
                                        start: 25,
                                      ),
                                      child: TextField(
                                        onSubmitted: (value) {
                                          widget.userModel!.email = value;
                                        },
                                        controller: _emailController,
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
                                      start: 25,
                                    ),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        widget.userModel!.phone = value;
                                      },
                                      controller: _phoneController,
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
                                      start: 25,
                                    ),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        widget.userModel!.gender = value;
                                      },
                                      controller: _genderController,
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
