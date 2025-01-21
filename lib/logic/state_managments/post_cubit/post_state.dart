// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'post_cubit.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class PostPickingState extends PostState {}

final class PostPickedState extends PostState {}

final class PostPickedErrorState extends PostState {}

final class RemoveImageState extends PostState {}

class PostUplodingState extends PostState {}

class PostUplodedState extends PostState {}

class PostUplodeErrorState extends PostState {}

class PostCreatingState extends PostState {}

class PostCreatedState extends PostState {
  final PostModel posts;
  PostCreatedState(this.posts);
}

class PostLikedState extends PostState {}

class PostLikeErrorState extends PostState {
  final String error;
  PostLikeErrorState(this.error);
}

class PostLoadingState extends PostState {}

class NoPostsState extends PostState {}

class PostLoadedState extends PostState {
  final List<PostModel> posts;
  PostLoadedState({
    required this.posts,
  });
}
class UserPostsWithDataLoadedState extends PostState {
  final UserModel user;
  final List<PostModel> posts;

  UserPostsWithDataLoadedState({required this.user, required this.posts});
}

class AllPostsWithUserLoadedState extends PostState {
  final List<Map<String, Object>> posts;
  AllPostsWithUserLoadedState(
    this.posts,
  );
}

class PostLoadedErrorState extends PostState {
  final String error;
  PostLoadedErrorState(this.error);
}
class VideoInitializedState extends PostState {
  final String postId;
  VideoInitializedState(this.postId);
}