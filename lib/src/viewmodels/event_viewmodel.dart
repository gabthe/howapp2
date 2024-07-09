// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/models/personal_profile.dart';
import 'package:howapp2/src/models/profile_resume.dart';
import 'package:howapp2/src/repositories/profile_repository.dart';
import 'package:howapp2/src/services/user_service.dart';
import 'package:howapp2/src/utils/enums.dart';

class EventViewmodel {
  ApiState fetchingEvent;
  Event? event;
  GoogleMapController? googleMapController;
  EventViewmodel({
    required this.fetchingEvent,
    this.event,
    this.googleMapController,
  });

  EventViewmodel copyWith({
    ApiState? fetchingEvent,
    Event? event,
    GoogleMapController? googleMapController,
  }) {
    return EventViewmodel(
      fetchingEvent: fetchingEvent ?? this.fetchingEvent,
      event: event ?? this.event,
      googleMapController: googleMapController ?? this.googleMapController,
    );
  }
}

class EventViewmodelNotifier extends StateNotifier<EventViewmodel> {
  final String eventId;
  final ProfileRepository profileRepo;
  final UserService userService;
  final UserServiceNotifier userServiceNotifier;
  EventViewmodelNotifier({
    required this.eventId,
    required this.profileRepo,
    required this.userService,
    required this.userServiceNotifier,
  }) : super(EventViewmodel(fetchingEvent: ApiState.idle)) {
    init();
  }

  init() async {
    try {} catch (e) {
      print(e);
      rethrow;
    }
  }

  addNewInterestedToEvent(Event event) async {
    PersonalProfile myProfile = userService.myPersonalProfile!;
    userServiceNotifier.addUserInterestInEvent(eventId);
    await profileRepo.addInterestedToEvent(
      profileResume: ProfileResume(
        id: myProfile.userId,
        displayName: myProfile.displayName,
        username: myProfile.username,
        photoUrl: myProfile.photoUrl,
      ),
      event: event,
    );
  }

  removeInterestFromEvent(Event event) async {
    PersonalProfile myProfile = userService.myPersonalProfile!;
    userServiceNotifier.removeUserInterestInEvent(eventId);
    await profileRepo.removeInterestedFromEvent(
      profileResume: ProfileResume(
        id: myProfile.userId,
        displayName: myProfile.displayName,
        username: myProfile.username,
        photoUrl: myProfile.photoUrl,
      ),
      event: event,
    );
  }

  setMapController(GoogleMapController controller) {
    state = state.copyWith(googleMapController: controller);
  }
}

final eventViewmodelProvider = StateNotifierProvider.autoDispose
    .family<EventViewmodelNotifier, EventViewmodel, String>((ref, id) {
  return EventViewmodelNotifier(
    eventId: id,
    userService: ref.watch(userServiceProvider),
    profileRepo: ref.watch(profileRepoProvider),
    userServiceNotifier: ref.read(userServiceProvider.notifier),
  );
});
