class PostModel {
  final String postId;
  final String uid;
  final String postImage;
  final String postType;
  final String caption;
  late final int likeCount;
  final List<String> likes;
  final DateTime timestamp;

  PostModel({
    required this.postId,
    required this.uid,
    required this.postImage,
    required this.postType,
    required this.caption,
    required this.likeCount,
    required this.likes,
    required this.timestamp,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      uid: json['uid'],
      postImage: json['postImage'],
      postType: json['postType'],
      caption: json['caption'],
      likeCount: json['likeCount'],
      likes: List<String>.from(json['likes']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'uid': uid,
      'postImage': postImage,
      'postType': postType,
      'caption': caption,
      'likeCount': likeCount,
      'likes': likes,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
