import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileResume {
  String id;
  String displayName;
  String username;
  String? photoUrl;
  ProfileResume({
    required this.id,
    required this.displayName,
    required this.username,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'username': username,
      'photoUrl': photoUrl,
    };
  }

  factory ProfileResume.fromMap(Map<String, dynamic> map) {
    return ProfileResume(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      username: map['username'] as String,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileResume.fromJson(String source) =>
      ProfileResume.fromMap(json.decode(source) as Map<String, dynamic>);
}
