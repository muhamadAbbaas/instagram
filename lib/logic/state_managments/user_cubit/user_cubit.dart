// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/data/local/cash_helper.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:instagram/presentation/screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserCubit extends Cubit<UserState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? currentUser;

  UserCubit() : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of(context);

  Future<void> signUp({
    required String fullName,
    required String email,
    required String userName,
    required String password,
  }) async {
    emit(SignInLoadingState());
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        // Create a UserModel object
        currentUser = UserModel(
          fullName: fullName,
          email: email,
          userName: userName,
          uid: user.uid,
          phone: '',
          bio: '',
          website: '',
          profileImage: '',
          followers: [],
          following: [],
        );

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(currentUser!.toMap());

        emit(SignInSuccessState(user.uid));
      }
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LogInLoadingState());
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        // Fetch user data from Firestore and update the currentUser
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        currentUser = UserModel.fromJson(userDoc.data()!);
        await CacheHelper.setData(key: 'uid', value: user.uid);
        emit(LoginSuccessState(user.uid));
      }
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> checkLoginStatus() async {
    emit(CheckLoginStatusLoadingState());
    try {
      final storedUid = CacheHelper.getData(key: 'uid');

      if (storedUid != null) {
        // Fetch user data using the stored UID
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(storedUid)
            .get();

        if (userDoc.exists) {
          currentUser = UserModel.fromJson(userDoc.data()!);
          emit(CheckLoginStatusSuccessState(currentUser!));
        } else {
          emit(CheckLoginStatusErrorState('User data not found.'));
        }
      } else {
        emit(CheckLoginStatusErrorState('No user logged in.'));
      }
    } catch (e) {
      emit(CheckLoginStatusErrorState('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await CacheHelper.deleteData(key: 'uid');
      currentUser = null;
      emit(LoggedOutState());
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      emit(LogOutErrorState(e.toString()));
    }
  }

  File? profileImage;
  ImagePicker picker = ImagePicker();

  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedState());
    } else {
      print('No image to preview');
      emit(ProfileImagePickErrorState());
    }
  }

  Future<void> uploadProfileImage({required String uid}) async {
    emit(ProfileImageUploadingState());
    if (profileImage == null) return;
    //generate a unique file path
    final fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final path = 'uploads/$fileName';
    final supabase = Supabase.instance.client;
    //upload the image to supabase storage
    await supabase.storage
        .from('profile_images')
        .upload(path, profileImage!)
        .then((value) {
      print(value + '&&&####################');
      final publicUrl =
          supabase.storage.from('profile_images').getPublicUrl(path);
      updateUserData(
        updatedFields: {
          'profileImage': publicUrl,
        },
      );
      emit(ProfileImageUploadedState(profileImage: publicUrl));
    }).catchError((error) {
      print(error);
      emit(ProfileImageUploadErrorState());
    });
  }

  void removeMedia() {
    profileImage = null;
    emit(RemoveImageState());
  }

  void updateUserData({
    required Map<String, dynamic> updatedFields,
  }) async {
    if (currentUser == null) return;

    emit(UserDateUpdatingState());

    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

      await userRef.update(updatedFields);
      await getUserData(currentUser!.uid!);
      emit(UserDataUpdatedState());
    } catch (e) {
      emit(UserDataUpdateErrorState(e.toString()));
    }
  }

  Future<void> getUserData(String uid) async {
    emit(GetUserDataLoadingState());
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        final user = UserModel.fromJson(userDoc.data()!);
        currentUser = user;
        emit(GetUserDataLoadedState(user));
      } else {
        emit(GetUserDataLoadErrorState(
            "User document not found or data is invalid."));
      }
    } on FirebaseException catch (e) {
      emit(GetUserDataLoadErrorState("Firestore Error: ${e.message}"));
    } catch (e) {
      emit(GetUserDataLoadErrorState("An unexpected error occurred: $e"));
    }
  }

  Future<void> getAllUsers() async {
    emit(GetAllUsersLoadingState());

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final users =
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      emit(GetAllUsersLoadedState(users));
    } catch (e) {
      emit(GetAllUserDataLoadErrorState(e.toString()));
    }
  }

  Future<void> followUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      // Add target user ID to the "following" list of the current user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({
        'following': FieldValue.arrayUnion([targetUserId]),
      });

      // Add current user ID to the "followers" list of the target user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .update({
        'followers': FieldValue.arrayUnion([currentUserId]),
      });

      emit(FollowUserSuccessState());
    } catch (e) {
      emit(FollowUserErrorState(e.toString()));
    }
  }

  Future<void> unfollowUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    try {
      // Remove target user ID from the "following" list of the current user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({
        'following': FieldValue.arrayRemove([targetUserId]),
      });

      // Remove current user ID from the "followers" list of the target user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .update({
        'followers': FieldValue.arrayRemove([currentUserId]),
      });
      emit(UnfollowUserSuccessState());
    } catch (e) {
      emit(UnfollowUserErrorState(e.toString()));
    }
  }

  Future<int> getFollowersCount(String userId) async {
    try {
      final followers = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('followers')
          .get();
      return followers.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getFollowingCount(String userId) async {
    try {
      final following = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('following')
          .get();
      return following.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> initializeUser() async {
    final storedUid = CacheHelper.getData(key: 'uid');

    if (storedUid != null) {
      await getUserData(storedUid);
    }
  }
}
