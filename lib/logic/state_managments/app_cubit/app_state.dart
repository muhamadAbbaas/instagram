// ignore_for_file: must_be_immutable

part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitialState extends AppState {}

final class CreatePostScreenState extends AppState {}

final class ChangeButtomNavSuccessState extends AppState {}

final class ChangeButtomNavErrorState extends AppState {}

final class GetUserDataLoadingState extends AppState {}

final class GetUserDataSuccessState extends AppState {}

final class GetUserDataErrorState extends AppState {}

final class PickedProfileImageLoadingState extends AppState {}

final class PickedProfileImageSuccessState extends AppState {}

final class PickedProfileImageErrorState extends AppState {}

final class PickedPostImageLoadingState extends AppState {}

final class PickedPostImageSuccessState extends AppState {}

final class PickedPostImageErrorState extends AppState {}

final class UpdateUserDataErrorState extends AppState {}

final class UploadProfileImageLoadingState extends AppState {}

final class UploadProfileImageSuccessState extends AppState {}

final class UploadProfileImageErrorState extends AppState {}

final class UploadPostImageLoadingState extends AppState {}

final class UploadPostImageSuccessState extends AppState {}

final class UploadPostImageErrorState extends AppState {}

final class CreatePostLoadingState extends AppState {}

final class CreatePostSuccessState extends AppState {}

final class CreatePostErrorState extends AppState {}

final class RemoveImageState extends AppState {}

final class GetPostsSuccessState extends AppState {}

final class GetPostsErrorState extends AppState {}

final class LikePostsLoadingState extends AppState {}

final class LikePostsSuccessState extends AppState {}

final class LikePostsErrorState extends AppState {}

final class LogoutSuccessState extends AppState {}

final class LogoutErrorState extends AppState {}

final class GetAllUsersLoadingState extends AppState {}

final class GetAllUsersSuccessState extends AppState {}

final class GetAllUsersErrorState extends AppState {}

final class SendMessageSuccessState extends AppState {}

final class SendMessageErrorState extends AppState {}

final class GetMessageSuccessState extends AppState {}

final class PickedStoryImageLoadingState extends AppState {}

final class PickedStoryImageSuccessState extends AppState {
  File image;
  PickedStoryImageSuccessState({required this.image});
}

final class PickedStoryImageErrorState extends AppState {}

final class UploadStoryImageLoadingState extends AppState {}

final class UploadStoryImageSuccessState extends AppState {}

final class UploadStoryImageErrorState extends AppState {}

final class CreateStoryLoadingState extends AppState {}

final class CreateStorySuccessState extends AppState {}

final class CreateStoryErrorState extends AppState {}

final class GetStoriesSuccessState extends AppState {}

final class GetStoriesErrorState extends AppState {}

final class FollowingUserSuccessState extends AppState {}

final class FollowingUserErrorState extends AppState {}

final class UpdatePostErrorState extends AppState {}

final class PostDislikedState extends AppState {}

final class PostLikedState extends AppState {}
