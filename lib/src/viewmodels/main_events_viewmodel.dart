// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/repositories/events_repository.dart';
import 'package:howapp2/src/utils/enums.dart';

class MainEventsViewmodel {
  ApiState fetchingEvents;
  List<Event> allEvents;
  List<List<Event>> banners;
  MainEventsViewmodel({
    required this.fetchingEvents,
    required this.allEvents,
    required this.banners,
  });

  MainEventsViewmodel copyWith({
    ApiState? fetchingEvents,
    List<Event>? allEvents,
    List<List<Event>>? banners,
  }) {
    return MainEventsViewmodel(
      fetchingEvents: fetchingEvents ?? this.fetchingEvents,
      allEvents: allEvents ?? this.allEvents,
      banners: banners ?? this.banners,
    );
  }
}

class MainEventsViewmodelNotifier extends StateNotifier<MainEventsViewmodel> {
  final EventsRepository eventsRepo;
  final bool isExperience;
  MainEventsViewmodelNotifier({
    required this.eventsRepo,
    required this.isExperience,
  }) : super(
          MainEventsViewmodel(
            fetchingEvents: ApiState.idle,
            allEvents: [],
            banners: [],
          ),
        ) {
    init();
  }
  init() async {
    try {
      state = state.copyWith(fetchingEvents: ApiState.pending);
      List<Event> events =
          await eventsRepo.fetchHighlightedEvents(isExperience: isExperience);

      events.sort(
        (a, b) {
          return a.highlightIndex!.compareTo(b.highlightIndex!);
        },
      );

      List<List<Event>> bannerList = [];

      int quantityOfSublists = (events.length / 4).floor();
      for (var i = 0; i <= quantityOfSublists; i++) {
        List<Event> newlist = [];
        var constant = (i * 4);
        for (var j = 0; j < 4; j++) {
          if ((j + constant) < events.length) {
            newlist.add(events[j + constant]);
          }
        }

        bannerList.add(newlist);
      }

      state = state.copyWith(
        allEvents: events,
        banners: bannerList,
      );
      print(state.banners[0].length);
      state = state.copyWith(fetchingEvents: ApiState.succeeded);
    } catch (e) {
      state = state.copyWith(fetchingEvents: ApiState.error);
      print(e);
    }
  }
}

final mainEventsViewmodelProvider = StateNotifierProvider.family<
    MainEventsViewmodelNotifier, MainEventsViewmodel, bool>(
  (ref, isExperience) {
    return MainEventsViewmodelNotifier(
      isExperience: isExperience,
      eventsRepo: ref.watch(eventsRepoProvider),
    );
  },
);
