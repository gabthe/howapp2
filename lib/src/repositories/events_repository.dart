import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/models/profile_resume.dart';

class EventsRepository {
  Future<List<ProfileResume>> getInterestedList(String eventId) async {
    try {
      // Referência ao documento específico na coleção events
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data();
        if (data != null && data.containsKey('interestedList')) {
          var dataAsDynamic = data['interestedList'] as List<dynamic>?;
          if (dataAsDynamic == null) {
            return [];
          }
          return dataAsDynamic.map(
            (e) {
              return ProfileResume.fromMap(e);
            },
          ).toList();
        }
      }
      return [];
    } catch (e) {
      print('Erro ao buscar interestedList: $e');
      rethrow;
    }
  }

  Future<List<Event>> publishedEventsById({required String creatorId}) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('events')
          .where('creatorId', isEqualTo: creatorId)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs
          .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Event>> fetchHighlightedEvents(
      {required bool isExperience}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('events')
        .where('isHighlighted', isEqualTo: true)
        .where('isExperience', isEqualTo: isExperience)
        .get();

    return querySnapshot.docs
        .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

final eventsRepoProvider = Provider<EventsRepository>((ref) {
  return EventsRepository();
});
