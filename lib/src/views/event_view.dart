import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/services/user_service.dart';
import 'package:howapp2/src/viewmodels/event_viewmodel.dart';
import 'package:howapp2/src/views/main_events_view.dart';

class EventView extends ConsumerWidget {
  final Event event;
  const EventView({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewmodel = ref.watch(
      eventViewmodelProvider(event.id),
    );
    var notifier = ref.read(
      eventViewmodelProvider(event.id).notifier,
    );
    var userService = ref.watch(userServiceProvider);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              toolbarHeight: 40,
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
                          children: [
                            IconButton(
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                              icon: Icon(Icons.arrow_back_ios),
                              color: Colors.white,
                            ),
                            Text(
                              event.name,
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).pushNamed('viewProfile',
                                    extra: {
                                      'isMyProfile': false,
                                      'profileId': event.creatorId
                                    });
                              },
                              child: Text(event.creatorName),
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: (9 / 16) * MediaQuery.of(context).size.width + 50,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: (9 / 16) * MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        imageUrl: event.bannerUrl,
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(imageUrl: event.photoUrl),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 120,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 120,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.event),
                                        Text(
                                          event.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_month),
                                        Text(formattedDate(event.date)),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                if (userService.myPersonalProfile != null)
                                  Column(
                                    children: [
                                      if (userService
                                          .listOfEventsThatUserHasInterest
                                          .any(
                                        (id) {
                                          return id == event.id;
                                        },
                                      ))
                                        IconButton(
                                          onPressed: () {
                                            notifier
                                                .removeInterestFromEvent(event);
                                          },
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                          ),
                                        ),
                                      if (!userService
                                          .listOfEventsThatUserHasInterest
                                          .any(
                                        (id) {
                                          return id == event.id;
                                        },
                                      ))
                                        IconButton(
                                          onPressed: () {
                                            notifier
                                                .addNewInterestedToEvent(event);
                                          },
                                          icon: const Icon(
                                            Icons.favorite_outline,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: event.eventTags.map(
                        (e) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red[900],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(e.tagName),
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        Flexible(child: Text(event.fullAdress)),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: GoogleMap(
                          markers: {
                            Marker(
                              markerId: MarkerId(event.fullAdress),
                              infoWindow: InfoWindow(title: event.fullAdress),
                              position: LatLng(event.latitude, event.longitude),
                            )
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(event.latitude, event.longitude),
                            zoom: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Cronograma do evento: '),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          )),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Nome'),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month),
                                Text(
                                  'Horario',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: event.activities.map(
                        (e) {
                          return Container(
                            padding: const EdgeInsets.all(4),
                            color: Colors.grey[800],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(e.name)),
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.schedule),
                                      Text(
                                        formattedDateWithHours(e.start),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          )),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed(
                            'interestedInEvent',
                            extra: event,
                          );
                        },
                        child: const Text('Lista de interessados'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('How Store'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Comprar ingresso'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
