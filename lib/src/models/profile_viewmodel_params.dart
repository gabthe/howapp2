// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileViewmodelParams {
  String id;
  bool isFirebaseId;
  ProfileViewmodelParams({
    required this.id,
    required this.isFirebaseId,
  });

  @override
  bool operator ==(covariant ProfileViewmodelParams other) {
    if (identical(this, other)) return true;

    return other.id == id && other.isFirebaseId == isFirebaseId;
  }

  @override
  int get hashCode => id.hashCode ^ isFirebaseId.hashCode;
}
