import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:howapp2/src/models/commerce_type.dart';
import 'package:howapp2/src/models/commercial_profile.dart';
import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/models/personal_profile.dart';
import 'package:howapp2/src/models/profile_resume.dart';

class ProfileRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addInterestedToEvent({
    required ProfileResume profileResume,
    required Event event,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.id)
          .update({
        'interestedList': FieldValue.arrayUnion([
          profileResume.toMap(),
        ]),
      });
      await FirebaseFirestore.instance
          .collection('personal_profiles')
          .doc(profileResume.id)
          .update({
        'interestedInEvents': FieldValue.arrayUnion([
          event.id,
        ]),
      });
      print('Evento adicionado à lista interestedInEvents');
    } catch (e) {
      print('Erro ao adicionar evento à lista interestedInEvents: $e');
      rethrow;
    }
  }

  Future<void> removeInterestedFromEvent({
    required ProfileResume profileResume,
    required Event event,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.id)
          .update({
        'interestedList': FieldValue.arrayRemove([
          profileResume.toMap(),
        ]),
      });
      await FirebaseFirestore.instance
          .collection('personal_profiles')
          .doc(profileResume.id)
          .update({
        'interestedInEvents': FieldValue.arrayRemove([
          event.id,
        ]),
      });
      print('Perfil removido da lista interestedList');
    } catch (e) {
      print('Erro ao remover perfil da lista interestedList: $e');
      rethrow;
    }
  }

  Future<void> retrieveEventsImInterested({
    required String profileId,
    required String eventId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('personal_profiles')
          .doc(profileId)
          .get();
      print('Evento adicionado à lista interestedInEvents');
    } catch (e) {
      print('Erro ao adicionar evento à lista interestedInEvents: $e');
      rethrow;
    }
  }

  Future<List<CommerceType>> getCommerceTypes() async {
    try {
      var commerceTypeQuerySnapshot =
          await _firestore.collection('commerce_types').get();
      var commerceTypeList = commerceTypeQuerySnapshot.docs.map(
        (e) {
          return CommerceType.fromMap(e.data());
        },
      ).toList();
      return commerceTypeList;
    } catch (e) {
      throw Exception('Error fetching commerce types: $e');
    }
  }

  Future<bool> isValidUsername(String username) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('personal_profiles')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro ao verificar o username: $e');
      rethrow;
    }
  }

  Future<String> uploadImageToFirebase(File image, String username) async {
    print('uploading');
    try {
      // Create a reference to the Firebase Storage location
      final storageRef = FirebaseStorage.instance.ref().child(
          'files/$username/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file to Firebase Storage
      await storageRef.putFile(image);

      // Get the download URL
      final downloadURL = await storageRef.getDownloadURL();

      print('Image uploaded successfully. Download URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> createPersonalProfile(PersonalProfile profile) async {
    try {
      await _firestore.collection('personal_profiles').doc(profile.userId).set(
            profile.toMap(),
          );
      print('Created new commercial profile');
    } catch (e) {
      throw Exception('Error creating profile: $e');
    }
  }

  Future<void> createProfile(CommercialProfile profile) async {
    try {
      await _firestore.collection('commercial_profiles').doc(profile.id).set(
            profile.toMap(),
          );
      print('Created new commercial profile');
    } catch (e) {
      throw Exception('Error creating profile: $e');
    }
  }

  Future<List<String>> getInterestedInEventsOfAUser(String profileId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('personal_profiles')
          .doc(profileId)
          .get();

      if (doc.exists) {
        List<String> interestedInEvents =
            List<String>.from(doc['interestedInEvents']);
        return interestedInEvents;
      } else {
        throw Exception('Documento não encontrado');
      }
    } catch (e) {
      print('Erro ao buscar interestedInEvents: $e');
      rethrow;
    }
  }

  getProfile(String id, bool isFirebaseId) async {
    try {
      if (isFirebaseId) {
        var profile = await _firestore
            .collection('personal_profiles')
            .where(
              'firebaseId',
              isEqualTo: id,
            )
            .get();
        if (profile.docs.isEmpty) {
          var profile = await _firestore
              .collection('commercial_profiles')
              .where(
                'firebaseId',
                isEqualTo: id,
              )
              .get();
          if (profile.docs.isEmpty) {
            return;
          }
          return CommercialProfile.fromMap(profile.docs.first.data());
        } else {
          return PersonalProfile.fromMap(profile.docs.first.data());
        }
      } else {
        var profile = await _firestore
            .collection('personal_profiles')
            .where(
              'id',
              isEqualTo: id,
            )
            .get();
        if (profile.docs.isEmpty) {
          var profile = await _firestore
              .collection('commercial_profiles')
              .where(
                'id',
                isEqualTo: id,
              )
              .get();
          if (profile.docs.isEmpty) {
            return;
          }
          return CommercialProfile.fromMap(profile.docs.first.data());
        } else {
          return PersonalProfile.fromMap(profile.docs.first.data());
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

final profileRepoProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});
