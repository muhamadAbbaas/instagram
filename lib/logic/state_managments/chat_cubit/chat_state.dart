import 'package:instagram/logic/model/chat/chat_model.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class SendMessageLoadingState extends ChatState {}

final class SendMessageSuccessState extends ChatState {}

final class SendMessageErrorState extends ChatState {}

final class GetMessageLoadingState extends ChatState {}

final class GetMessageSuccessState extends ChatState {
  List<ChatModel> messagesList;
  GetMessageSuccessState({required this.messagesList});
}

final class GetMessageErrorState extends ChatState {
  final String error;

  GetMessageErrorState({required this.error});
}
