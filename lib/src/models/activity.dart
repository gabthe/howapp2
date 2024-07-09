// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Activity {
  String id;
  String name;
  DateTime start;
  Activity({
    String? id,
    required this.name,
    required this.start,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'start': start.millisecondsSinceEpoch,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as String,
      name: map['name'] as String,
      start: DateTime.fromMillisecondsSinceEpoch(map['start'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Activity.fromJson(String source) =>
      Activity.fromMap(json.decode(source) as Map<String, dynamic>);
}
