// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:howapp2/src/models/localization.dart';
import 'package:howapp2/src/models/commerce_type.dart';
import 'package:howapp2/src/models/commercial_profile.dart';
import 'package:howapp2/src/repositories/location_repository.dart';
import 'package:howapp2/src/repositories/profile_repository.dart';
import 'package:howapp2/src/services/firebase_auth_service.dart';
import 'package:howapp2/src/utils/colors.dart';
import 'package:howapp2/src/utils/enums.dart';

class CreateCommercialProfileViewmodel {
  ApiState fetchingCommerceTypes;
  String nameText;
  String usernameText;
  CommerceType? commerceType;
  List<CommerceType> commerceTypes;
  Localization? selectedLocalization;
  File? pickedPhoto;
  File? pickedBanner;
  TextEditingController nameController;
  Map<String, TextEditingController> listOfTextControllers;
  GoogleMapController? googleMapController;
  CreateCommercialProfileViewmodel({
    required this.fetchingCommerceTypes,
    required this.nameText,
    required this.usernameText,
    this.commerceType,
    required this.commerceTypes,
    this.selectedLocalization,
    this.pickedPhoto,
    this.pickedBanner,
    required this.nameController,
    required this.listOfTextControllers,
    this.googleMapController,
  });

  CreateCommercialProfileViewmodel copyWith({
    ApiState? fetchingCommerceTypes,
    String? nameText,
    String? usernameText,
    CommerceType? commerceType,
    List<CommerceType>? commerceTypes,
    Localization? selectedLocalization,
    File? pickedPhoto,
    File? pickedBanner,
    TextEditingController? nameController,
    Map<String, TextEditingController>? listOfTextControllers,
    GoogleMapController? googleMapController,
  }) {
    return CreateCommercialProfileViewmodel(
      fetchingCommerceTypes:
          fetchingCommerceTypes ?? this.fetchingCommerceTypes,
      nameText: nameText ?? this.nameText,
      usernameText: usernameText ?? this.usernameText,
      commerceType: commerceType ?? this.commerceType,
      commerceTypes: commerceTypes ?? this.commerceTypes,
      selectedLocalization: selectedLocalization ?? this.selectedLocalization,
      pickedPhoto: pickedPhoto ?? this.pickedPhoto,
      pickedBanner: pickedBanner ?? this.pickedBanner,
      nameController: nameController ?? this.nameController,
      listOfTextControllers:
          listOfTextControllers ?? this.listOfTextControllers,
      googleMapController: googleMapController ?? this.googleMapController,
    );
  }
}

class CreateCommercialProfileNotifier
    extends StateNotifier<CreateCommercialProfileViewmodel> {
  ProfileRepository profileRepo;
  FirebaseAuthService authService;
  LocalizationRepository localizationRepo;
  CreateCommercialProfileNotifier({
    required this.profileRepo,
    required this.authService,
    required this.localizationRepo,
  }) : super(
          CreateCommercialProfileViewmodel(
            fetchingCommerceTypes: ApiState.idle,
            nameText: '',
            usernameText: '',
            nameController: TextEditingController(),
            commerceTypes: [],
            listOfTextControllers: {
              'searchCityInput': TextEditingController(),
              'cityNameController': TextEditingController(),
              'federativeUnitNameController': TextEditingController(),
              'addressNumberController': TextEditingController(),
              'fullAddressController': TextEditingController(),
              'postalCodeController': TextEditingController(),
              'addressNameController': TextEditingController(),
              'fullAddressNameController': TextEditingController(),
            },
          ),
        );

  selectPhoto({
    required bool isFromCamera,
  }) async {
    late XFile? pickedImage;
    if (isFromCamera) {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (pickedImage != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cortar',
              toolbarColor: Colors.black,
              toolbarWidgetColor: howPrimaryColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cortar',
          ),
        ],
      );
      if (croppedFile != null) {
        state = state.copyWith(
          pickedPhoto: File(croppedFile.path),
        );
      }
    }
  }

  selectBanner({
    required bool isFromCamera,
  }) async {
    late XFile? pickedImage;
    if (isFromCamera) {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (pickedImage != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 256,
          ratioY: 144,
        ),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cortar',
              toolbarColor: Colors.black,
              toolbarWidgetColor: howPrimaryColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cortar',
          ),
        ],
      );
      if (croppedFile != null) {
        state = state.copyWith(
          pickedBanner: File(croppedFile.path),
        );
      }
    }
  }

  updateNameText(String text) {
    state = state.copyWith(nameText: text.trim());
  }

  updateUsernameText(String text) {
    // Remove espaços e caracteres não alfanuméricos (exceto underline e ponto)
    String treatedText = text.replaceAll(RegExp(r'[^a-zA-Z0-9._]'), '');

    // Adiciona @ no começo
    treatedText = '@' + treatedText;

    // Atualiza o estado com o texto tratado
    state = state.copyWith(usernameText: treatedText.toLowerCase());
  }

  getCommerceTypes() async {
    try {
      state = state.copyWith(fetchingCommerceTypes: ApiState.pending);
      var commerceTypes = await profileRepo.getCommerceTypes();
      state = state.copyWith(
        commerceTypes: commerceTypes,
        fetchingCommerceTypes: ApiState.succeeded,
      );
      return commerceTypes;
    } catch (e, st) {
      log('create_commercial_profile_viewmodel', error: e, stackTrace: st);
    }
  }

  setCommerceType(CommerceType commerceType) {
    state = state.copyWith(commerceType: commerceType);
  }

  createCommercialProfile() async {
    try {
      var photoUrl = await profileRepo.uploadImageToFirebase(
        state.pickedPhoto!,
        state.usernameText,
      );
      var bannerUrl = await profileRepo.uploadImageToFirebase(
        state.pickedBanner!,
        state.usernameText,
      );
      var newCommercialProfile = CommercialProfile(
        id: const Uuid().v4(),
        firebaseId: authService.getCurrentUser()!.uid,
        name: state.nameText,
        username: state.usernameText,
        profilePictureUrl: photoUrl,
        bannerPictureUrl: bannerUrl,
        publishedEvents: [],
      );
      await profileRepo.createProfile(newCommercialProfile);
    } catch (e) {
      rethrow;
    }
  }

  setLocalization(Localization localization) {
    state = state.copyWith(selectedLocalization: localization);
    moveToLocation(LatLng(localization.lat, localization.lng));
  }

  void onMapCreated(GoogleMapController controller) {
    state = state.copyWith(googleMapController: controller);
    moveToLocation(
      LatLng(state.selectedLocalization!.lat, state.selectedLocalization!.lng),
    );
    setControllersText();
  }

  moveToLocation(LatLng target) {
    state.googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: 18,
        ),
      ),
    );
  }

  setControllersText() {
    var localization = state.selectedLocalization;

    state.listOfTextControllers['addressNameController']!.text =
        localization!.adressName;
    state.listOfTextControllers['fullAddressNameController']!.text =
        localization.fullAddress;
    state.listOfTextControllers['cityNameController']!.text =
        localization.cityName;
    state.listOfTextControllers['federativeUnitNameController']!.text =
        localization.federativeUnitLongeName;
    state.listOfTextControllers['addressNumberController']!.text =
        localization.numberName;
    state.listOfTextControllers['fullAddressController']!.text =
        localization.fullAddress;
    state.listOfTextControllers['postalCodeController']!.text =
        localization.postalCode;
  }
}

final createCommercialProfileProvider = StateNotifierProvider.autoDispose<
    CreateCommercialProfileNotifier, CreateCommercialProfileViewmodel>((ref) {
  return CreateCommercialProfileNotifier(
    localizationRepo: ref.watch(locationRepositoryProvider),
    authService: ref.watch(firebaseAuthServiceProvider),
    profileRepo: ref.watch(profileRepoProvider),
  );
});
