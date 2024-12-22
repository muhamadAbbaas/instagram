
class StoryModel {
  String? userName;
  String? uId;
  String? dateTime;
  String? userImage;
  String? storyImage;
  bool? hasStory;

  StoryModel({
    required this.userName,
    required this.uId,
    required this.dateTime,
    required this.userImage,
    required this.storyImage,
    this.hasStory,
  });

  StoryModel.fromJson(Map<String, dynamic>json) {
    userName = json['userName'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    userImage = json['userImage'];
    storyImage = json['storyImage'];
    hasStory = json['hasStory'] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'uId': uId,
      'dateTime': dateTime,
      'userImage': userImage,
      'storyImage': storyImage,
      'hasStory': hasStory,
    };
  }
}
