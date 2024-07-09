// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:howapp2/src/models/commercial_profile.dart';
import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/models/personal_profile.dart';
import 'package:howapp2/src/repositories/events_repository.dart';
import 'package:howapp2/src/repositories/profile_repository.dart';
import 'package:howapp2/src/services/firebase_auth_service.dart';

class UserService {
  List<String> listOfEventsThatUserHasInterest;
  List<String> listOfEventsThatUserHasBeen;
  List<Event>? publishedEvents;
  PersonalProfile? myPersonalProfile;
  CommercialProfile? myCommercialProfile;
  UserService({
    required this.listOfEventsThatUserHasInterest,
    required this.listOfEventsThatUserHasBeen,
    this.publishedEvents,
    this.myPersonalProfile,
    this.myCommercialProfile,
  });

  UserService copyWith({
    List<String>? listOfEventsThatUserHasInterest,
    List<String>? listOfEventsThatUserHasBeen,
    List<Event>? publishedEvents,
    PersonalProfile? myPersonalProfile,
    CommercialProfile? myCommercialProfile,
  }) {
    return UserService(
      listOfEventsThatUserHasInterest: listOfEventsThatUserHasInterest ??
          this.listOfEventsThatUserHasInterest,
      listOfEventsThatUserHasBeen:
          listOfEventsThatUserHasBeen ?? this.listOfEventsThatUserHasBeen,
      publishedEvents: publishedEvents ?? this.publishedEvents,
      myPersonalProfile: myPersonalProfile ?? this.myPersonalProfile,
      myCommercialProfile: myCommercialProfile ?? this.myCommercialProfile,
    );
  }
}

class UserServiceNotifier extends StateNotifier<UserService> {
  final ProfileRepository profileRepo;
  final EventsRepository eventRepo;
  final FirebaseAuthService authService;
  UserServiceNotifier({
    required this.profileRepo,
    required this.authService,
    required this.eventRepo,
  }) : super(
          UserService(
            listOfEventsThatUserHasBeen: [],
            listOfEventsThatUserHasInterest: [],
          ),
        ) {
    init();
  }
  init() async {
    try {
      print('INIT USER SERIVCE');
      var profile =
          await profileRepo.getProfile(authService.getCurrentUser()!.uid, true);
      print('INIT USER SERIVCE $profile');

      if (profile.runtimeType == CommercialProfile) {
        var prof = profile as CommercialProfile;
        var publishedEvents =
            await eventRepo.publishedEventsById(creatorId: prof.id);
        state = state.copyWith(
          myCommercialProfile: prof,
          publishedEvents: publishedEvents,
        );
      } else {
        var prof = profile as PersonalProfile;
        var myInterestedEvents =
            await profileRepo.getInterestedInEventsOfAUser(prof.userId);
        print('GABS ${myInterestedEvents.length}');

        state = state.copyWith(
          myPersonalProfile: prof,
          listOfEventsThatUserHasInterest: myInterestedEvents,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  addUserInterestInEvent(String eventId) {
    state = state.copyWith(listOfEventsThatUserHasInterest: [
      ...state.listOfEventsThatUserHasInterest,
      eventId,
    ]);
  }

  removeUserInterestInEvent(String eventId) {
    state = state.copyWith(
      listOfEventsThatUserHasInterest:
          state.listOfEventsThatUserHasInterest.where(
        (element) {
          return element != eventId;
        },
      ).toList(),
    );
  }
}

final userServiceProvider =
    StateNotifierProvider.autoDispose<UserServiceNotifier, UserService>((ref) {
  return UserServiceNotifier(
      profileRepo: ref.watch(profileRepoProvider),
      authService: ref.watch(firebaseAuthServiceProvider),
      eventRepo: ref.watch(eventsRepoProvider));
});
