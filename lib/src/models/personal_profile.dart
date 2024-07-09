// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:howapp2/src/models/localization.dart';

class PersonalProfile {
  String userId;
  String firebaseId;
  String displayName;
  String username;
  int? gender;
  String? photoUrl;
  String? bannerUrl;
  List<String> eventsThatUserHasBeen;
  List<String> interestedInEvents;
  Localization localization;
  DateTime dateCreated;
  PersonalProfile({
    required this.userId,
    required this.firebaseId,
    required this.displayName,
    required this.username,
    this.gender,
    this.photoUrl,
    this.bannerUrl,
    required this.eventsThatUserHasBeen,
    required this.interestedInEvents,
    required this.localization,
    required this.dateCreated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'firebaseId': firebaseId,
      'displayName': displayName,
      'username': username,
      'gender': gender,
      'photoUrl': photoUrl,
      'bannerUrl': bannerUrl,
      'eventsThatUserHasBeen': eventsThatUserHasBeen,
      'interestedInEvents': interestedInEvents,
      'localization': localization.toMap(),
      'dateCreated': dateCreated.millisecondsSinceEpoch,
    };
  }

  factory PersonalProfile.fromMap(Map<String, dynamic> map) {
    return PersonalProfile(
      userId: map['userId'] as String,
      firebaseId: map['firebaseId'] as String,
      displayName: map['displayName'] as String,
      username: map['username'] as String,
      gender: map['gender'] != null ? map['gender'] as int : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      bannerUrl: map['bannerUrl'] != null ? map['bannerUrl'] as String : null,
      eventsThatUserHasBeen:
          List<String>.from((map['eventsThatUserHasBeen'] as List<dynamic>)),
      interestedInEvents:
          List<String>.from((map['interestedInEvents'] as List<dynamic>)),
      localization:
          Localization.fromMap(map['localization'] as Map<String, dynamic>),
      dateCreated:
          DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalProfile.fromJson(String source) =>
      PersonalProfile.fromMap(json.decode(source) as Map<String, dynamic>);
}
