import 'dart:convert';

import 'package:howapp2/src/models/event.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommercialProfile {
  String id;
  String firebaseId;
  String name;
  String username;
  String profilePictureUrl;
  String bannerPictureUrl;
  List<Event> publishedEvents;
  CommercialProfile({
    required this.id,
    required this.firebaseId,
    required this.name,
    required this.username,
    required this.profilePictureUrl,
    required this.bannerPictureUrl,
    required this.publishedEvents,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firebaseId': firebaseId,
      'name': name,
      'username': username,
      'profilePictureUrl': profilePictureUrl,
      'bannerPictureUrl': bannerPictureUrl,
      'publishedEvents': publishedEvents.map((x) => x.toMap()).toList(),
    };
  }

  factory CommercialProfile.fromMap(Map<String, dynamic> map) {
    return CommercialProfile(
      id: map['id'] as String,
      firebaseId: map['firebaseId'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      profilePictureUrl: map['profilePictureUrl'] as String,
      bannerPictureUrl: map['bannerPictureUrl'] as String,
      publishedEvents: List<Event>.from(
        (map['publishedEvents'] as List<dynamic>).map<Event>(
          (x) => Event.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommercialProfile.fromJson(String source) =>
      CommercialProfile.fromMap(json.decode(source) as Map<String, dynamic>);
}
