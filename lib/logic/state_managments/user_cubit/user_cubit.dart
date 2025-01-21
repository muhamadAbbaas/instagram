// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/logic/state_managments/user_cubit/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          profileImage: '', // Default profile image
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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);

        emit(LoginSuccessState(user.uid));
      }
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }

  Future<void> checkLoginStatus() async {
    emit(CheckLoginStatusLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUid = prefs.getString('uid');

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
          emit(CheckLoginStatusErrorState('User not found.'));
        }
      } else {
        emit(CheckLoginStatusErrorState('No user logged in.'));
      }
    } catch (e) {
      emit(CheckLoginStatusErrorState(e.toString()));
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    currentUser = null;

    // Remove UID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');

    emit(LoggedOutState());
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

  void updateUserData({
    required Map<String, dynamic> updatedFields,
  }) async {
    if (currentUser == null) return;
    emit(UserDateUpdatingState());
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

      // Update Firestore with new fields
      await userRef.update(updatedFields);
      getUserData(currentUser!.uid!);

      emit(UserDataUpdatedState());
    } catch (e) {
      emit(UserDataUpdateErrorState(e.toString()));
    }
  }

  void getUserData(String uid) async {
    emit(GetUserDataLoadingState());
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        currentUser = UserModel.fromJson(userDoc.data()!);
        emit(GetUserDataLoadedState(currentUser!));
      } else {
        emit(GetUserDataLoadErrorState("User not found."));
      }
    } catch (e) {
      emit(GetUserDataLoadErrorState(e.toString()));
    }
  }

  Future<void> getAllUsers() async {
    emit(GetAllUsersLoadingState());

    try {
      // Fetch users from Firestore
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final users =
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      emit(GetAllUsersLoadedState(users));
    } catch (e) {
      emit(GetAllUserDataLoadErrorState(e.toString()));
    }
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
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

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
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

  UserModel? getCurrentUser() {
    return currentUser;
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
}
  
  // void updateUserData({
  //   String? fullName,
  //   String? email,
  //   String? userName,
  //   String? website,
  //   String? bio,
  //   String? phone,
  //   String? gender,
  //   String? profileImage,
  // }) async {
  //   userModel = UserModel(
  //     fullName: fullName ?? userModel!.fullName,
  //     email: email ?? userModel!.email,
  //     userName: userName ?? userModel!.userName,
  //     uid: userModel!.uId,
  //     website: website ?? userModel!.website,
  //     bio: bio ?? userModel!.bio,
  //     phone: phone ?? userModel!.phone,
  //     gender: gender ?? userModel!.gender,
  //     profileImage: profileImage ?? userModel!.profileImage,
  //   );
  //   FirebaseFirestore.instance
  //       .collection('userInfo')
  //       .doc(userModel!.uId)
  //       .update(userModel!.toMap())
  //       .then((value) {
  //     getUserData();
  //   }).catchError((error) {
  //     emit(UpdateUserDataErrorState());
  //   });
  // }

