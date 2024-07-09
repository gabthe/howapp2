// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class EventTag {
  String id;
  String tagName;

  EventTag({
    String? id, // Allow null id to generate one if not provided
    required this.tagName,
  }) : id = id ?? const Uuid().v4(); // Generate a new UUID if id is null

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tagName': tagName,
    };
  }

  factory EventTag.fromMap(Map<String, dynamic> map) {
    return EventTag(
      id: map['id'] as String,
      tagName: map['tagName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventTag.fromJson(String source) =>
      EventTag.fromMap(json.decode(source) as Map<String, dynamic>);
}
