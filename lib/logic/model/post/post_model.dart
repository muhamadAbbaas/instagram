class PostModel {
  String? userName;
  String? fullName;
  String? uId;
  String? caption;
  String? dateTime;
  String? userImage;
  String? postImage;
  String? postId;
  int? likeCount;
  List<String>? likes;

  PostModel({
    required this.userName,
    required this.fullName,
    required this.uId,
    required this.caption,
    required this.dateTime,
    required this.userImage,
    required this.postImage,
    this.postId,
    this.likeCount,
    this.likes,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    fullName = json['fullName'];
    uId = json['uId'];
    caption = json['caption'];
    dateTime = json['dateTime'];
    userImage = json['userImage'];
    postImage = json['postImage'];
    postId = json['postId'] ?? '';
    likeCount = json['likeCount'] ?? 0;
    likes = List<String>.from(json['likes'] ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'fullName': fullName,
      'uId': uId,
      'caption': caption,
      'dateTime': dateTime,
      'userImage': userImage,
      'postImage': postImage,
      'postId': postId,
      'likeCount': likeCount,
      'likes': likes,
    };
  }
}
