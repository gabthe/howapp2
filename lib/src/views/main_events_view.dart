import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/utils/enums.dart';
import 'package:howapp2/src/viewmodels/main_events_viewmodel.dart';
import 'package:howapp2/src/views/navigator_view.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

formattedDate(DateTime datetime) {
  String formattedDate = DateFormat('dd/MM/yyyy').format(datetime);
  return formattedDate;
}

formattedDateWithHours(DateTime datetime) {
  String formattedDate = DateFormat('HH:mm').format(datetime);
  return formattedDate;
}

class MainEventsView extends ConsumerWidget {
  const MainEventsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewmodel = ref.watch(mainEventsViewmodelProvider(false));

    if (viewmodel.fetchingEvents == ApiState.pending) {
      return const BannersLoadScaffold();
    }
    return BannersLoadedScaffold(viewmodel: viewmodel);
  }
}

class BannersLoadedScaffold extends StatelessWidget {
  const BannersLoadedScaffold({
    super.key,
    required this.viewmodel,
  });

  final MainEventsViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: decorationGradient(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 1.25,
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayAnimationDuration: const Duration(
                        seconds: 1,
                      ),
                      autoPlayInterval: const Duration(seconds: 8),
                      viewportFraction: 1,
                      height: MediaQuery.of(context).size.width * 1.25,
                    ),
                    itemCount: viewmodel.banners[0].length,
                    itemBuilder: (context, index, realIndex) {
                      var event = viewmodel.banners[0][index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              print('Ir carrocel big');
                              GoRouter.of(context)
                                  .pushNamed('eventView', extra: event);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              color: Colors.black,
                              child: CachedNetworkImage(
                                imageUrl: event.carouselBigUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromARGB(255, 20, 0, 0),
                                    highlightColor:
                                        const Color.fromARGB(255, 60, 0, 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: event.photoUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1.25 -
                                              (MediaQuery.of(context)
                                                      .size
                                                      .width +
                                                  8),
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1.25 -
                                              (MediaQuery.of(context)
                                                      .size
                                                      .width +
                                                  8),
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IconAndTextBigCarouselElementWidget(
                                                    iconData: Icons.person,
                                                    text: event.creatorName,
                                                  ),
                                                  IconAndTextBigCarouselElementWidget(
                                                    iconData: Icons.event,
                                                    text: event.name,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  IconAndTextBigCarouselElementWidget(
                                                    iconData:
                                                        Icons.calendar_month,
                                                    text: formattedDate(
                                                        event.date),
                                                  ),
                                                  IconAndTextBigCarouselElementWidget(
                                                    iconData: Icons.label,
                                                    text: event
                                                        .eventTags[0].tagName,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        IconAndTextBigCarouselElementWidget(
                                          iconData: Icons.location_on,
                                          text: event.fullAdress.split('-')[0],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (viewmodel.banners.length > 1)
                  SmallCarouselWidget(
                    events: viewmodel.banners[1],
                  ),
                if (viewmodel.banners.length > 2)
                  SmallCarouselWidget(
                    events: viewmodel.banners[2],
                  ),
                if (viewmodel.banners.length > 3)
                  SmallCarouselWidget(
                    events: viewmodel.banners[3],
                  ),
                if (viewmodel.banners.length > 4)
                  SmallCarouselWidget(
                    events: viewmodel.banners[4],
                  ),
                if (viewmodel.banners.length > 5)
                  SmallCarouselWidget(
                    events: viewmodel.banners[5],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BannersLoadScaffold extends StatelessWidget {
  const BannersLoadScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: decorationGradient(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 1.25,
                color: Colors.grey,
                child: Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 20, 0, 0),
                      highlightColor: const Color.fromARGB(255, 60, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        color: Colors.green,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 1.25 -
                          MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 20, 0, 0),
                            highlightColor: const Color.fromARGB(255, 60, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1.25 -
                                  (MediaQuery.of(context).size.width + 8),
                              height: MediaQuery.of(context).size.width * 1.25 -
                                  (MediaQuery.of(context).size.width + 8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromARGB(255, 20, 0, 0),
                                    highlightColor:
                                        const Color.fromARGB(255, 60, 0, 0),
                                    child: Container(
                                      height: 30,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: Shimmer.fromColors(
                                    baseColor:
                                        const Color.fromARGB(255, 20, 0, 0),
                                    highlightColor:
                                        const Color.fromARGB(255, 60, 0, 0),
                                    child: Container(
                                      height: 30,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 20, 0, 0),
                  highlightColor: const Color.fromARGB(255, 60, 0, 0),
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IconAndTextBigCarouselElementWidget extends StatelessWidget {
  final IconData iconData;
  final String text;
  const IconAndTextBigCarouselElementWidget({
    super.key,
    required this.text,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class SmallCarouselWidget extends StatelessWidget {
  final List<Event> events;
  const SmallCarouselWidget({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: (events.length * 0.5).ceil(),
      options: CarouselOptions(
        viewportFraction: 1,
        scrollPhysics: events.length < 3
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        autoPlay: false,
        height: MediaQuery.of(context).size.width * 0.7,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        int firstIndex = index * 2;
        int secondIndex = firstIndex + 1;
        Event firstEvent = events[firstIndex];
        Event? secondEvent;
        if (secondIndex < events.length) {
          secondEvent = events[secondIndex];
        }

        return Row(
          children: [
            const SizedBox(width: 6),
            Expanded(
              child: SmallCarouselEventElement(
                event: firstEvent,
              ),
            ),
            const SizedBox(width: 6),
            if (secondIndex <
                events
                    .length) // Verifica se o secondIndex está dentro do limite
              Expanded(
                child: SmallCarouselEventElement(
                  event: secondEvent!,
                ),
              ),
            const SizedBox(width: 6),
          ],
        );
      },
    );
  }
}

class SmallCarouselEventElement extends StatelessWidget {
  const SmallCarouselEventElement({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            print('Ir carrocel small');
            GoRouter.of(context).pushNamed('eventView', extra: event);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                imageUrl: event.carouselSmallUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 20, 0, 0),
                    highlightColor: const Color.fromARGB(255, 60, 0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 20, 0, 0),
                    highlightColor: const Color.fromARGB(255, 60, 0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  imageUrl: event.photoUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 20, 0, 0),
                      highlightColor: const Color.fromARGB(255, 60, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person),
                      Flexible(
                        child: Text(
                          event.creatorName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.event),
                      Flexible(
                        child: Text(
                          event.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      Flexible(
                        child: Text(
                          formattedDate(event.date),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
