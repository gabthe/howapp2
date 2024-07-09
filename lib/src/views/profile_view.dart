import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:howapp2/src/models/profile_infos.dart';
import 'package:howapp2/src/models/profile_viewmodel_params.dart';
import 'package:howapp2/src/services/firebase_auth_service.dart';
import 'package:howapp2/src/utils/enums.dart';
import 'package:howapp2/src/viewmodels/profile_viewmodel.dart';
import 'package:howapp2/src/views/navigator_view.dart';

getProportion(double width) {
  return (9 / 16) * width;
}

class ProfileView extends ConsumerWidget {
  final bool isMyProfile;
  final String? profileId;
  const ProfileView({
    super.key,
    required this.isMyProfile,
    this.profileId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authService = ref.watch(firebaseAuthServiceProvider);
    var params = ProfileViewmodelParams(
        id: profileId == null ? authService.getCurrentUser()!.uid : profileId!,
        isFirebaseId: profileId == null);
    var viewmodel = ref.watch(
      profileViewmodelProvider(params),
    );
    var notifier = ref.read(
      profileViewmodelProvider(params).notifier,
    );
    if (viewmodel.fetchingProfile != ApiState.pending) {
      if (viewmodel.personalProfile != null) {
        return Scaffold(
          // perfil pessoal
          body: SafeArea(
            child: Column(
              children: [
                ProfileHeaderWidget(
                  profileInfos: ProfileInfos(
                    bannerPictureUrl: viewmodel.personalProfile!.bannerUrl,
                    firebaseId: viewmodel.personalProfile!.firebaseId,
                    name: viewmodel.personalProfile!.displayName,
                    profileId: viewmodel.personalProfile!.userId,
                    profilePictureUrl: viewmodel.personalProfile!.photoUrl,
                    username: viewmodel.personalProfile!.username,
                  ),
                ),
                if (isMyProfile)
                  TextButton(
                    onPressed: () {
                      ref.watch(firebaseAuthServiceProvider).signOut();
                    },
                    child: Text('Logout'),
                  ),
              ],
            ),
          ),
        );
      }
      if (viewmodel.commercialProfile != null) {
        // perfil comercial
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  toolbarHeight: 50,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54
                          .withOpacity(0.5), // Fundo semi-transparente
                    ),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                        child: Container(
                          color: Colors.black.withOpacity(0),
                          child: SafeArea(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    GoRouter.of(context).pop();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios),
                                  color: Colors.white,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      viewmodel.commercialProfile!.name,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      viewmodel.commercialProfile!.username,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  '${viewmodel.publishedEvents?.length} Eventos publicados',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              decoration: decorationGradient(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeaderWidget(
                    profileInfos: ProfileInfos(
                      bannerPictureUrl:
                          viewmodel.commercialProfile!.bannerPictureUrl,
                      firebaseId: viewmodel.commercialProfile!.firebaseId,
                      name: viewmodel.commercialProfile!.name,
                      profileId: viewmodel.commercialProfile!.id,
                      profilePictureUrl:
                          viewmodel.commercialProfile!.profilePictureUrl,
                      username: viewmodel.commercialProfile!.username,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Eventos publicados: '),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewmodel.publishedEvents!.length,
                      itemBuilder: (context, index) {
                        var event = viewmodel.publishedEvents![index];
                        return InkWell(
                          onTap: () {
                            GoRouter.of(context)
                                .pushNamed('eventView', extra: event);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: (3 / 20) *
                                      MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: CachedNetworkImage(
                                      imageUrl: event.cardImageUrl,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(18)),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: (3 / 20) *
                                            MediaQuery.of(context).size.width,
                                        height: (3 / 20) *
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 50, 0, 0),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl: event.photoUrl,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        children: [
                                          Text(event.name),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (isMyProfile)
                    TextButton(
                      onPressed: () {
                        ref.watch(firebaseAuthServiceProvider).signOut();
                      },
                      child: Text('Logout'),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return Scaffold(
      body: SafeArea(
        child: viewmodel.fetchingProfile == ApiState.pending
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed('createProfile');
                  },
                  child: const Text('Complete seu perfil'),
                ),
              ),
      ),
    );
  }
}

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({
    super.key,
    required this.profileInfos,
  });
  final ProfileInfos profileInfos;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: getProportion(MediaQuery.of(context).size.width) + 40,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: getProportion(MediaQuery.of(context).size.width),
            child: profileInfos.bannerPictureUrl != null
                ? CachedNetworkImage(
                    imageUrl: profileInfos.bannerPictureUrl!,
                  )
                : Container(
                    color: Colors.grey[800],
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 12,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(80),
                    ),
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: profileInfos.profilePictureUrl != null
                          ? CachedNetworkImage(
                              imageUrl: profileInfos.profilePictureUrl!,
                            )
                          : Container(
                              child: const Icon(
                                Icons.photo_camera_outlined,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileInfos.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${profileInfos.username}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
