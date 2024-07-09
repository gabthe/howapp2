import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Localization {
  String numberName;
  String adressName;
  String neighborhoodName;
  String cityName;
  String federativeUnitLongeName;
  String federativeUnitShortName;
  String countryShortName;
  String countryLongName;
  String postalCode;
  String fullAddress;
  double lat;
  double lng;
  Localization({
    required this.numberName,
    required this.adressName,
    required this.neighborhoodName,
    required this.cityName,
    required this.federativeUnitLongeName,
    required this.federativeUnitShortName,
    required this.countryShortName,
    required this.countryLongName,
    required this.postalCode,
    required this.fullAddress,
    required this.lat,
    required this.lng,
  });

  factory Localization.fromMap(Map<String, dynamic> map) {
    return Localization(
      numberName: map['numberName'] as String,
      adressName: map['adressName'] as String,
      neighborhoodName: map['neighborhoodName'] as String,
      cityName: map['cityName'] as String,
      federativeUnitLongeName: map['federativeUnitLongeName'] as String,
      federativeUnitShortName: map['federativeUnitShortName'] as String,
      countryShortName: map['countryShortName'] as String,
      countryLongName: map['countryLongName'] as String,
      postalCode: map['postalCode'] as String,
      fullAddress: map['fullAddress'] as String,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'numberName': numberName,
      'adressName': adressName,
      'neighborhoodName': neighborhoodName,
      'cityName': cityName,
      'federativeUnitLongeName': federativeUnitLongeName,
      'federativeUnitShortName': federativeUnitShortName,
      'countryShortName': countryShortName,
      'countryLongName': countryLongName,
      'postalCode': postalCode,
      'fullAddress': fullAddress,
      'lat': lat,
      'lng': lng,
    };
  }

  String toJson() => json.encode(toMap());

  factory Localization.fromJson(String source) =>
      Localization.fromMap(json.decode(source) as Map<String, dynamic>);
}
