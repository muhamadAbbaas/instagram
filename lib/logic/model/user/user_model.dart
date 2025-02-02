class UserModel {
  String? fullName;
  String? email;
  String? userName;
  String? uid;
  String? website;
  String? bio;
  String? phone;
  String? gender;
  String? profileImage;
  List<String>? followers;
  List<String>? following;

  UserModel({
    required this.fullName,
    required this.email,
    required this.userName,
    required this.uid,
    this.website,
    this.bio,
    this.phone,
    this.gender,
    this.profileImage,
    this.followers,
    this.following,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      email: json['email'],
      userName: json['userName'],
      uid: json['uid'],
      website: json['website'],
      bio: json['bio'],
      phone: json['phone'],
      gender: json['gender'],
      profileImage: json['profileImage'],
      followers: List<String>.from(json['followers']),
      following: List<String>.from(json['following']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'userName': userName,
      'uid': uid,
      'website': website,
      'bio': bio,
      'phone': phone,
      'gender': gender,
      'profileImage': profileImage,
      'followers': followers,
      'following': following,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? userName,
    String? uid,
    String? website,
    String? bio,
    String? phone,
    String? gender,
    String? profileImage,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      website: website ?? this.website,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      uid: uid ?? this.uid,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
