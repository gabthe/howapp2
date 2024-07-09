// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:howapp2/src/models/commercial_profile.dart';
import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/models/personal_profile.dart';
import 'package:howapp2/src/models/profile_viewmodel_params.dart';
import 'package:howapp2/src/repositories/events_repository.dart';
import 'package:howapp2/src/repositories/profile_repository.dart';
import 'package:howapp2/src/utils/enums.dart';

class ProfileViewmodel {
  ApiState fetchingProfile;
  CommercialProfile? commercialProfile;
  PersonalProfile? personalProfile;
  List<Event>? publishedEvents;
  ProfileViewmodel({
    required this.fetchingProfile,
    this.commercialProfile,
    this.personalProfile,
    this.publishedEvents,
  });

  ProfileViewmodel copyWith({
    ApiState? fetchingProfile,
    CommercialProfile? commercialProfile,
    PersonalProfile? personalProfile,
    List<Event>? publishedEvents,
  }) {
    return ProfileViewmodel(
      fetchingProfile: fetchingProfile ?? this.fetchingProfile,
      commercialProfile: commercialProfile ?? this.commercialProfile,
      personalProfile: personalProfile ?? this.personalProfile,
      publishedEvents: publishedEvents ?? this.publishedEvents,
    );
  }
}

class ProfileViewmodelNotifier extends StateNotifier<ProfileViewmodel> {
  ProfileRepository profileRepo;
  EventsRepository eventsRepo;
  String profileId;
  bool isFirebaseId;
  ProfileViewmodelNotifier({
    required this.profileRepo,
    required this.profileId,
    required this.isFirebaseId,
    required this.eventsRepo,
  }) : super(ProfileViewmodel(
          fetchingProfile: ApiState.idle,
        )) {
    init();
  }

  init() async {
    try {
      state = state.copyWith(fetchingProfile: ApiState.pending);
      var profile = await profileRepo.getProfile(profileId, isFirebaseId);
      if (profile.runtimeType == CommercialProfile) {
        var prof = profile as CommercialProfile;
        var publishedEvents =
            await eventsRepo.publishedEventsById(creatorId: prof.id);
        state = state.copyWith(
          publishedEvents: publishedEvents,
          commercialProfile: profile,
          fetchingProfile: ApiState.succeeded,
        );
      } else {
        state = state.copyWith(
          personalProfile: profile,
          fetchingProfile: ApiState.succeeded,
        );
      }
    } catch (e, st) {
      state = state.copyWith(fetchingProfile: ApiState.error);
      log('profile_viewmodel_error', error: e, stackTrace: st);
    }
  }
}

final profileViewmodelProvider = StateNotifierProvider.family<
    ProfileViewmodelNotifier,
    ProfileViewmodel,
    ProfileViewmodelParams>((ref, params) {
  return ProfileViewmodelNotifier(
    profileRepo: ref.watch(profileRepoProvider),
    profileId: params.id,
    eventsRepo: ref.watch(eventsRepoProvider),
    isFirebaseId: params.isFirebaseId,
  );
});
