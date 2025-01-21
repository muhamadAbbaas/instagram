// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'story_cubit.dart';

abstract class StoryState {}

class StoryInitial extends StoryState {}

class StoryPickingState extends StoryState {}

class StoryPickedState extends StoryState {
  File image;
  StoryPickedState({
    required this.image,
  });
}

class StoryPickErrorState extends StoryState {}

class StoryUploadingState extends StoryState {}

class StoryUploadedState extends StoryState {}

class StoryUploadErrorState extends StoryState {
  final String error;
  StoryUploadErrorState(this.error);
}

class StoryCreatingState extends StoryState {}

class StoryCreatedState extends StoryState {
  final StoryModel stories;
  StoryCreatedState(this.stories);
}

class StoryCreateErrorState extends StoryState {
  String error;
  StoryCreateErrorState(
    this.error,
  );
}

class StoryLoadingState extends StoryState {}

class StoryLoadedState extends StoryState {
  final List<StoryModel> stories;
  StoryLoadedState(this.stories);
}

class StoryLoadErrorState extends StoryState {
  final String error;
  StoryLoadErrorState(this.error);
}

class StoryAddErrorState extends StoryState {
  final String error;
  StoryAddErrorState(this.error);
}

class StoryUpdatedState extends StoryState {}

class StoryUpdateErrorState extends StoryState {
  final String error;
  StoryUpdateErrorState(this.error);
}
