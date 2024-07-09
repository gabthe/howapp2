// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:howapp2/src/models/localization.dart';
import 'package:howapp2/src/models/localization_search_result.dart';
import 'package:howapp2/src/models/personal_profile.dart';
import 'package:howapp2/src/repositories/location_repository.dart';
import 'package:howapp2/src/repositories/profile_repository.dart';
import 'package:howapp2/src/services/firebase_auth_service.dart';
import 'package:howapp2/src/utils/enums.dart';

class PersonalProfileViewmodel {
  ApiState apiState;
  ApiState verifyingUsername;
  ApiState searchingLocation;
  ApiState creatingProfile;
  GlobalKey<FormState> createPersonalProfileFormKey;
  TextEditingController usernameController;
  FocusNode usernameFocusNode;
  TextEditingController displayNameController;
  FocusNode displaynameFocusNode;
  TextEditingController cityInputController;
  FocusNode cityInputFocusNode;
  bool hasUsernameError;
  bool cansSendLocalizationError;
  String? usernameErrorString;
  int? selectedGender;
  List<LocalizationSearchResult> results;
  LocalizationSearchResult? selectedLocalizationResult;
  Localization? selectedLocalization;
  bool verifiedUsername;
  PersonalProfileViewmodel({
    required this.apiState,
    required this.verifyingUsername,
    required this.searchingLocation,
    required this.creatingProfile,
    required this.createPersonalProfileFormKey,
    required this.usernameController,
    required this.usernameFocusNode,
    required this.displayNameController,
    required this.displaynameFocusNode,
    required this.cityInputController,
    required this.cityInputFocusNode,
    required this.hasUsernameError,
    required this.cansSendLocalizationError,
    this.usernameErrorString,
    this.selectedGender,
    required this.results,
    this.selectedLocalizationResult,
    this.selectedLocalization,
    required this.verifiedUsername,
  });

  PersonalProfileViewmodel copyWith({
    ApiState? apiState,
    ApiState? verifyingUsername,
    ApiState? searchingLocation,
    ApiState? creatingProfile,
    GlobalKey<FormState>? createPersonalProfileFormKey,
    TextEditingController? usernameController,
    FocusNode? usernameFocusNode,
    TextEditingController? displayNameController,
    FocusNode? displaynameFocusNode,
    TextEditingController? cityInputController,
    FocusNode? cityInputFocusNode,
    bool? hasUsernameError,
    bool? cansSendLocalizationError,
    String? usernameErrorString,
    int? selectedGender,
    List<LocalizationSearchResult>? results,
    LocalizationSearchResult? selectedLocalizationResult,
    Localization? selectedLocalization,
    bool? verifiedUsername,
  }) {
    return PersonalProfileViewmodel(
      apiState: apiState ?? this.apiState,
      verifyingUsername: verifyingUsername ?? this.verifyingUsername,
      searchingLocation: searchingLocation ?? this.searchingLocation,
      creatingProfile: creatingProfile ?? this.creatingProfile,
      createPersonalProfileFormKey:
          createPersonalProfileFormKey ?? this.createPersonalProfileFormKey,
      usernameController: usernameController ?? this.usernameController,
      usernameFocusNode: usernameFocusNode ?? this.usernameFocusNode,
      displayNameController:
          displayNameController ?? this.displayNameController,
      displaynameFocusNode: displaynameFocusNode ?? this.displaynameFocusNode,
      cityInputController: cityInputController ?? this.cityInputController,
      cityInputFocusNode: cityInputFocusNode ?? this.cityInputFocusNode,
      hasUsernameError: hasUsernameError ?? this.hasUsernameError,
      cansSendLocalizationError:
          cansSendLocalizationError ?? this.cansSendLocalizationError,
      usernameErrorString: usernameErrorString ?? this.usernameErrorString,
      selectedGender: selectedGender ?? this.selectedGender,
      results: results ?? this.results,
      selectedLocalizationResult:
          selectedLocalizationResult ?? this.selectedLocalizationResult,
      selectedLocalization: selectedLocalization ?? this.selectedLocalization,
      verifiedUsername: verifiedUsername ?? this.verifiedUsername,
    );
  }
}

class PersonalProfileViewmodelNotifier
    extends StateNotifier<PersonalProfileViewmodel> {
  final ProfileRepository profileRepo;
  final LocalizationRepository localizationRepo;
  final FirebaseAuthService authService;
  PersonalProfileViewmodelNotifier({
    required this.profileRepo,
    required this.authService,
    required this.localizationRepo,
  }) : super(
          PersonalProfileViewmodel(
              apiState: ApiState.idle,
              verifyingUsername: ApiState.idle,
              displayNameController: TextEditingController(),
              usernameController: TextEditingController(),
              cityInputController: TextEditingController(),
              createPersonalProfileFormKey: GlobalKey<FormState>(),
              cityInputFocusNode: FocusNode(),
              displaynameFocusNode: FocusNode(),
              usernameFocusNode: FocusNode(),
              hasUsernameError: false,
              results: [],
              searchingLocation: ApiState.idle,
              verifiedUsername: false,
              cansSendLocalizationError: false,
              creatingProfile: ApiState.idle),
        ) {
    init();
  }

  init() async {
    try {
      print('GABS');
    } catch (e) {
      print(e);
    }
  }

  searchLocalization() async {
    try {
      state = state.copyWith(searchingLocation: ApiState.pending);
      print('SEARCHING');
      var localizationResults = await localizationRepo
          .getAddressMultipleResults(state.cityInputController.text);

      state = state.copyWith(results: localizationResults);
      state = state.copyWith(searchingLocation: ApiState.succeeded);
    } catch (e) {
      print(e);
      state = state.copyWith(searchingLocation: ApiState.error);

      rethrow;
    }
  }

  selectlocalizationResult(LocalizationSearchResult result) async {
    state = state.copyWith(selectedLocalizationResult: result);
    try {
      var localization =
          await localizationRepo.getAddress(LatLng(result.lat, result.lng));
      state = state.copyWith(
        selectedLocalization: localization,
        cansSendLocalizationError: false,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  setVerifyUsernameToFalse() {
    print('SETANDO VERIFIED PRA FALSE');
    state = state.copyWith(verifiedUsername: false);
  }

  verifyUsername() async {
    try {
      final regex = RegExp(r'^[a-zA-Z0-9_-]+$');
      if (!regex.hasMatch(state.usernameController.text.trim())) {
        state = state.copyWith(
          hasUsernameError: true,
          usernameErrorString:
              'Apenas letras, números, "-" e "_" são permitidos',
        );
        return;
      }
      state = state.copyWith(verifyingUsername: ApiState.pending);
      print('verificando username');
      await Future.delayed(Duration(seconds: 3));
      var result =
          await profileRepo.isValidUsername(state.usernameController.text);
      state = state.copyWith(
        verifyingUsername: ApiState.succeeded,
      );
      if (!result) {
        state = state.copyWith(
          hasUsernameError: true,
          usernameErrorString: 'Username já foi utilizado por outro usuário',
        );
      } else {
        state = state.copyWith(
          verifiedUsername: true,
          hasUsernameError: false,
        );
      }

      return result;
    } catch (e) {
      print(e);
      state = state.copyWith(
        verifyingUsername: ApiState.error,
      );

      return false;
    }
  }

  canSendLocalizationError() {
    state = state.copyWith(cansSendLocalizationError: true);
  }

  createPersonalProfile() async {
    try {
      print('CREATING');
      if (state.hasUsernameError) {
        return;
      }
      if (state.selectedLocalization == null) {
        return;
      }
      state = state.copyWith(creatingProfile: ApiState.pending);
      var prof = PersonalProfile(
        userId: const Uuid().v4(),
        firebaseId: authService.getCurrentUser()!.uid,
        displayName: state.displayNameController.text,
        username: state.usernameController.text,
        eventsThatUserHasBeen: [],
        interestedInEvents: [],
        localization: state.selectedLocalization!,
        dateCreated: DateTime.now(),
      );
      state = state.copyWith(creatingProfile: ApiState.succeeded);

      profileRepo.createPersonalProfile(prof);
    } catch (e) {
      print(e);
      state = state.copyWith(creatingProfile: ApiState.error);
      rethrow;
    }
  }
}

final createPersonalProfileViewmodelProvider =
    StateNotifierProvider.autoDispose<PersonalProfileViewmodelNotifier,
        PersonalProfileViewmodel>((ref) {
  return PersonalProfileViewmodelNotifier(
    profileRepo: ref.watch(profileRepoProvider),
    authService: ref.watch(firebaseAuthServiceProvider),
    localizationRepo: ref.watch(locationRepositoryProvider),
  );
});
