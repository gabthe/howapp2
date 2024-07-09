// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:howapp2/src/models/activity.dart';
import 'package:howapp2/src/models/event_tag.dart';
import 'package:howapp2/src/models/profile_resume.dart';

class Event {
  String id;
  String creatorId;
  String creatorName;
  String creatorUsername;
  String creatorProfilePictureUrl;
  String creatorBannerPictureUrl;
  String photoUrl;
  String bannerUrl;
  String carouselSmallUrl;
  String carouselBigUrl;
  String cardImageUrl;
  String name;
  String description;
  String fullAdress;
  double latitude;
  double longitude;
  DateTime date;
  bool hasTicketSelling;
  bool hasHowStore;
  bool isHighlighted;
  bool isExperience;

  int? highlightIndex;
  List<Activity> activities;
  List<EventTag> eventTags;
  List<ProfileResume> interestedList;
  Event({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    required this.creatorUsername,
    required this.creatorProfilePictureUrl,
    required this.creatorBannerPictureUrl,
    required this.photoUrl,
    required this.bannerUrl,
    required this.carouselSmallUrl,
    required this.carouselBigUrl,
    required this.cardImageUrl,
    required this.name,
    required this.description,
    required this.fullAdress,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.hasTicketSelling,
    required this.hasHowStore,
    required this.isHighlighted,
    required this.isExperience,
    this.highlightIndex,
    required this.activities,
    required this.eventTags,
    required this.interestedList,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorUsername': creatorUsername,
      'creatorProfilePictureUrl': creatorProfilePictureUrl,
      'creatorBannerPictureUrl': creatorBannerPictureUrl,
      'photoUrl': photoUrl,
      'bannerUrl': bannerUrl,
      'carouselSmallUrl': carouselSmallUrl,
      'carouselBigUrl': carouselBigUrl,
      'cardImageUrl': cardImageUrl,
      'name': name,
      'description': description,
      'fullAdress': fullAdress,
      'latitude': latitude,
      'longitude': longitude,
      'date': date.millisecondsSinceEpoch,
      'hasTicketSelling': hasTicketSelling,
      'hasHowStore': hasHowStore,
      'isHighlighted': isHighlighted,
      'isExperience': isExperience,
      'highlightIndex': highlightIndex,
      'activities': activities.map((x) => x.toMap()).toList(),
      'eventTags': eventTags.map((x) => x.toMap()).toList(),
      'interestedList': interestedList.map((x) => x.toMap()).toList(),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      creatorId: map['creatorId'] as String,
      creatorName: map['creatorName'] as String,
      creatorUsername: map['creatorUsername'] as String,
      creatorProfilePictureUrl: map['creatorProfilePictureUrl'] as String,
      creatorBannerPictureUrl: map['creatorBannerPictureUrl'] as String,
      photoUrl: map['photoUrl'] as String,
      bannerUrl: map['bannerUrl'] as String,
      carouselSmallUrl: map['carouselSmallUrl'] as String,
      carouselBigUrl: map['carouselBigUrl'] as String,
      cardImageUrl: map['cardImageUrl'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      fullAdress: map['fullAdress'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      hasTicketSelling: map['hasTicketSelling'] as bool,
      hasHowStore: map['hasHowStore'] as bool,
      isHighlighted: map['isHighlighted'] as bool,
      isExperience:
          map['isExperience'] != null ? map['isExperience'] as bool : false,
      highlightIndex:
          map['highlightIndex'] != null ? map['highlightIndex'] as int : null,
      activities: List<Activity>.from(
        (map['activities'] as List<dynamic>).map<Activity>(
          (x) => Activity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      eventTags: List<EventTag>.from(
        (map['eventTags'] as List<dynamic>).map<EventTag>(
          (x) => EventTag.fromMap(x as Map<String, dynamic>),
        ),
      ),
      interestedList: List<ProfileResume>.from(
        (map['interestedList'] as List<dynamic>).map<ProfileResume>(
          (x) => ProfileResume.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) =>
      Event.fromMap(json.decode(source) as Map<String, dynamic>);
}
