// ignore_for_file: prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/constants/consatant.dart';
import 'package:instagram/logic/model/chat/chat_model.dart';
import 'package:instagram/logic/model/post/post_model.dart';
import 'package:instagram/logic/model/story/story_model.dart';
import 'package:instagram/logic/model/user/user_model.dart';
import 'package:instagram/presentation/screens/create_post_screen.dart';
import 'package:instagram/presentation/screens/new_feeds_screen.dart';
import 'package:instagram/presentation/screens/notification_screen.dart';
import 'package:instagram/presentation/screens/profile.dart';
import 'package:instagram/presentation/screens/search_screen.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  PostModel? postModel;

  int currentIndex = 0;
  List screens = [
    NewFeedsScreen(),
    SearchScreen(),
    CreatePostScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  void changeButtomNavIndex(int index) {
    if (index == 2) {
      emit(CreatePostScreenState());
    } else {
      currentIndex = index;
      emit(ChangeButtomNavSuccessState());
    }
  }

  void getUserData() {
    emit(GetUserDataLoadingState());
    print(cashedUId);
    FirebaseFirestore.instance.collection('userInfo').doc(cashedUId).get().then(
      (value) {
        userModel = UserModel.fromJson(value);
        emit(GetUserDataSuccessState());
      },
    ).catchError((error) {
      emit(GetUserDataErrorState());
      print(error);
    });
  }

  ImagePicker picker = ImagePicker();

  //                                  ....... PROFILE IMAGE .......
  File? profileImage;
  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PickedProfileImageSuccessState());
    } else {
      print('No image to preview');
      emit(PickedProfileImageErrorState());
    }
  }

  Future<void> uploadProfileImage() async {
    emit(UploadProfileImageLoadingState());
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
      updateUserData(profileImage: publicUrl);
      emit(UploadProfileImageSuccessState());
    }).catchError((error) {
      print(error);
      emit(UploadProfileImageErrorState());
    });
  }

  void updateUserData({
    String? fullName,
    String? email,
    String? userName,
    String? website,
    String? bio,
    String? phone,
    String? gender,
    String? profileImage,
  }) async {
    userModel = UserModel(
      fullName: fullName ?? userModel!.fullName,
      email: email ?? userModel!.email,
      userName: userName ?? userModel!.userName,
      uId: userModel!.uId,
      website: website ?? userModel!.website,
      bio: bio ?? userModel!.bio,
      phone: phone ?? userModel!.phone,
      gender: gender ?? userModel!.gender,
      profileImage: profileImage ?? userModel!.profileImage,
    );
    FirebaseFirestore.instance
        .collection('userInfo')
        .doc(userModel!.uId)
        .update(userModel!.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateUserDataErrorState());
    });
  }

  //                                   ....... POST IMAGE ........
  File? postImage;
  Future<void> pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PickedPostImageSuccessState());
    } else {
      print('No image to preview');
      emit(PickedPostImageErrorState());
    }
  }

  // creating new post
  void uploadPostImage(
    String? dateTime,
    String? caption,
    File postImage,
  ) async {
    if (postImage == null) return;
    emit(UploadPostImageLoadingState());
    //generate a unique file path
    final fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final supabase = Supabase.instance.client;
    final path = 'uploads/$fileName';
    //upload the image to supabase storage
    await supabase.storage
        .from('post_images')
        .upload(path, postImage)
        .then((value) {
      final publicUrl = supabase.storage.from('post_images').getPublicUrl(path);
      createPost(
        dateTime: dateTime,
        caption: caption,
        postImage: publicUrl,
      );
    }).catchError((error) {
      print(error);
      emit(UploadPostImageErrorState());
    });
  }

  void createPost({
    String? dateTime,
    String? caption,
    String? postImage,
  }) {
    PostModel postModel = PostModel(
      fullName: userModel!.fullName,
      userName: userModel!.userName,
      userImage: userModel!.profileImage,
      uId: userModel!.uId,
      caption: caption,
      dateTime: dateTime,
      postImage: postImage,
      isLiked: false,
      likeNum: 0,
    );
    emit(CreatePostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void removeImage() {
    postImage = null;
    emit(RemoveImageState());
  }

  List<PostModel> postsList = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach(
        (element) {
          postsId.add(element.id);
          postsList.add(PostModel.fromJson(element));
          element.reference.collection('likes').get().then((value) {
            likes.add(value.docs.length);
          }).catchError((error) {
            print(error);
          });
        },
      );
      emit(GetPostsSuccessState());
    }).catchError((error) {
      print(error);
      emit(GetPostsErrorState());
    });
  }

  void postLikes({
    String? postId,
    bool? isLiked,
    int? likeNum,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set(
      {'likes': true},
    ).then(
      (value) {
        toggleLike(
          isLiked: isLiked,
          likeNum: likeNum,
          postId: postId,
        );
        emit(LikePostsSuccessState());
      },
    ).catchError(
      (error) {
        print(error);
        emit(LikePostsErrorState());
      },
    );
  }

  void toggleLike({
    bool? isLiked,
    int? likeNum,
    String? postId,
  }) async {
    if (isLiked == true) {
      isLiked = false;
      likeNum = likeNum! - 1;
      updatePost(
        postId: postId,
        isLiked: isLiked,
        likeNum: likeNum,
      );
      emit(PostDislikedState());
    }
    isLiked = true;
    likeNum = likeNum! + 1;
    updatePost(
      postId: postId,
      isLiked: isLiked,
      likeNum: likeNum,
    );
    emit(PostLikedState());
  }

  void updatePost({
    String? userName,
    String? fullName,
    String? caption,
    String? postImage,
    bool? isLiked,
    int? likeNum,
    String? postId,
  }) async {
     postModel = PostModel(
      userName: userName ?? userModel!.userName,
      fullName: fullName ?? userModel!.fullName,
      uId: userModel!.uId,
      caption: caption ?? postModel!.caption,
      dateTime: postModel!.dateTime,
      userImage: userModel!.profileImage,
      postImage: postImage,
      isLiked: isLiked ?? postModel!.isLiked,
      likeNum: likeNum ?? postModel!.likeNum,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(postModel!.toMap())
        .then((value) {
          getPosts();
        })
        .catchError((error) {
      emit(UpdatePostErrorState());
    });
  }

  List<UserModel> usersList = [];
  List<String> usersId = [];
  List<int> following = [];

  void getAllUsers() {
    emit(GetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('userInfo').get().then(
      (value) {
        value.docs.forEach(
          (element) {
            usersId.add(element.id);
            if (element['uId'] != userModel!.uId) {
              usersList.add(UserModel.fromJson(element));
              element.reference.collection('followers').get().then((value) {
                following.add(value.docs.length);
              }).catchError((error) {
                print(error);
              });
            }
          },
        );
        emit(GetAllUsersSuccessState());
      },
    ).catchError(
      (error) {
        emit(GetAllUsersErrorState());
        print(error);
      },
    );
  }

//                                         ...... Following Section ......
  void newFollower(String userId) {
    FirebaseFirestore.instance
        .collection('userInfo')
        .doc(userId)
        .collection('followers')
        .doc(userModel!.uId)
        .set(
      {'following': true},
    ).then(
      (value) {
        emit(FollowingUserSuccessState());
      },
    ).catchError(
      (error) {
        print(error);
        emit(FollowingUserErrorState());
      },
    );
  }

  //                                         ...... Chat Section ......
  void sendMessage({
    required String reciverId,
    required String dateTime,
    required String message,
  }) {
    ChatModel chatModel = ChatModel(
      senderId: userModel!.uId,
      reciverId: reciverId,
      dateTime: dateTime,
      message: message,
    );

    //set my chat
    FirebaseFirestore.instance
        .collection('userInfo')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .add(chatModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(error);
      emit(SendMessageErrorState());
    });

    //set receiver chat
    FirebaseFirestore.instance
        .collection('userInfo')
        .doc(reciverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(chatModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(error);
      emit(SendMessageErrorState());
    });
  }

  List<ChatModel> messagesList = [];
  void getMessage({
    required String reciverId,
  }) {
    FirebaseFirestore.instance
        .collection('userInfo')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen(
      (event) {
        messagesList = [];
        event.docs.forEach(
          (element) {
            messagesList.add(ChatModel.fromJson(element));
          },
        );
        emit(GetMessageSuccessState());
      },
    );
  }

  //                                       ...... Story Section ......

  File? storyImage;
  Future<void> pickStoryImage() async {
    emit(PickedStoryImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      storyImage = File(pickedFile.path);
      emit(PickedStoryImageSuccessState(image: storyImage!));
    } else {
      print('No image to preview');
      emit(PickedStoryImageErrorState());
    }
  }

  void uploadStoryImage({
    String? dateTime,
    File? storyImage,
  }) async {
    if (storyImage == null) return;
    emit(UploadStoryImageLoadingState());
    //generate a unique file path
    final fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final supabase = Supabase.instance.client;
    final path = 'uploads/$fileName';
    //upload the image to supabase storage
    await supabase.storage
        .from('story_images')
        .upload(path, storyImage)
        .then((value) {
      final publicUrl =
          supabase.storage.from('story_images').getPublicUrl(path);
      createStory(
        dateTime: dateTime,
        storyImage: publicUrl,
      );
    }).catchError((error) {
      print(error);
      emit(UploadStoryImageErrorState());
    });
  }

  void createStory({
    String? dateTime,
    String? storyImage,
  }) {
    StoryModel storyModel = StoryModel(
      userName: userModel!.userName,
      userImage: userModel!.profileImage,
      uId: userModel!.uId,
      dateTime: dateTime,
      storyImage: storyImage,
    );
    emit(CreateStoryLoadingState());
    FirebaseFirestore.instance
        .collection('stories')
        .add(storyModel.toMap())
        .then((value) {
      emit(CreateStorySuccessState());
    }).catchError((error) {
      print(error);
      emit(CreateStoryErrorState());
    });
  }

  List<StoryModel> storiesList = [];
  List<StoryModel> ownerStoriesList = [];

  void getStories() {
    FirebaseFirestore.instance.collection('stories').get().then((value) {
      value.docs.forEach(
        (element) {
          if (element['uId'] == userModel!.uId) {
            ownerStoriesList.add(StoryModel.fromJson(element));
          }
          storiesList.add(StoryModel.fromJson(element));
        },
      );
      emit(GetStoriesSuccessState());
    }).catchError((error) {
      print(error);
      emit(GetStoriesErrorState());
    });
  }
}












// void uploadProfileImage() {
  //   final storage = FirebaseStorage.instance;
  //   storage
  //       .ref()
  //       .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
  //       .putFile(profileImage!)
  //       .then((value) {
  //     value.ref.getDownloadURL().then((value) {
  //       print('Phooootooooooooooooooooooooooo' + value);
  //       updateUserData(profileImage: value);
  //       emit(UploadProfileImageSuccessState());
  //     }).catchError((error) {
  //       print(error);
  //       emit(UploadProfileImageErrorState());
  //     });
  //   }).catchError((error) {
  //     print(error);
  //     emit(UploadProfileImageErrorState());
  //   });
  // }

  