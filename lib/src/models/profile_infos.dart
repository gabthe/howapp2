import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileInfos {
  String profileId;
  String firebaseId;
  String? profilePictureUrl;
  String? bannerPictureUrl;
  String name;
  String username;
  ProfileInfos({
    required this.profileId,
    required this.firebaseId,
    this.profilePictureUrl,
    this.bannerPictureUrl,
    required this.name,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileId': profileId,
      'firebaseId': firebaseId,
      'profilePictureUrl': profilePictureUrl,
      'bannerPictureUrl': bannerPictureUrl,
      'name': name,
      'username': username,
    };
  }

  factory ProfileInfos.fromMap(Map<String, dynamic> map) {
    return ProfileInfos(
      profileId: map['profileId'] as String,
      firebaseId: map['firebaseId'] as String,
      profilePictureUrl: map['profilePictureUrl'] != null
          ? map['profilePictureUrl'] as String
          : null,
      bannerPictureUrl: map['bannerPictureUrl'] != null
          ? map['bannerPictureUrl'] as String
          : null,
      name: map['name'] as String,
      username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileInfos.fromJson(String source) =>
      ProfileInfos.fromMap(json.decode(source) as Map<String, dynamic>);
}
