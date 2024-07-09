import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:howapp2/src/models/localization.dart';
import 'package:howapp2/src/models/localization_search_result.dart';

class LocalizationRepository {
  final String apiKey = 'AIzaSyC2NIP3B6DR9v_2LKlHrGgkDu-wUeEnMeU';
  final Dio _dio = Dio();

  Future<Localization?> getAdressByInput(String searchInput) async {
    try {
      final encodedInput = Uri.encodeComponent(searchInput);
      final url =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$encodedInput&key=$apiKey';
      final response = await _dio.get(url);
      if (response.data['results'].isEmpty) {
        throw 'Nenhum resultado encontrado';
      }
      var latlng = LatLng(
        response.data['results'][0]['geometry']['location']['lat'],
        response.data['results'][0]['geometry']['location']['lng'],
      );
      var address = await getAddress(latlng);
      return address;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LocalizationSearchResult>> getAddressMultipleResults(
      String searchInput) async {
    try {
      final encodedInput = Uri.encodeComponent(searchInput);
      final url =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$encodedInput&key=$apiKey';
      final response = await _dio.get(url);
      if (response.data['results'].isEmpty) {
        return [];
      } else {
        List<dynamic> a = response.data['results'];
        var b = a.map(
          (e) {
            return LocalizationSearchResult(
              formattedAddress: e['formatted_address'],
              lat: e['geometry']['location']['lat'],
              lng: e['geometry']['location']['lng'],
            );
          },
        ).toList();
        return b;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Localization> getAddress(LatLng position) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';

      final response = await _dio.get(url);
      List<dynamic> adressComponents =
          response.data['results'][0]['address_components'];
      String numberName = adressComponents[0]['long_name'];
      String adressName = adressComponents[1]['long_name'];
      String neighborhoodName = adressComponents[2]['long_name'];
      String cityName = adressComponents[3]['long_name'];
      String federativeUnitLongeName = adressComponents[4]['long_name'];
      String federativeUnitShortName = adressComponents[4]['short_name'];
      String countryShortName = adressComponents[5]['short_name'];
      String countryLongName = adressComponents[5]['long_name'];
      String postalCode = adressComponents[6]['long_name'];
      String fullAddress = response.data['results'][0]['formatted_address'];
      double lat = response.data['results'][0]['geometry']['location']['lat'];
      double lng = response.data['results'][0]['geometry']['location']['lng'];
      Map<String, dynamic> dataMap = {
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
      return Localization.fromMap(dataMap);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

final locationRepositoryProvider = Provider<LocalizationRepository>((ref) {
  return LocalizationRepository();
});
