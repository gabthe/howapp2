import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommerceType {
  String id;
  String commerceTypeName;
  CommerceType({
    required this.id,
    required this.commerceTypeName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'commerceTypeName': commerceTypeName,
    };
  }

  factory CommerceType.fromMap(Map<String, dynamic> map) {
    return CommerceType(
      id: map['id'] as String,
      commerceTypeName: map['commerceTypeName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommerceType.fromJson(String source) =>
      CommerceType.fromMap(json.decode(source) as Map<String, dynamic>);
}
