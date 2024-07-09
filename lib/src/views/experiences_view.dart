import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:howapp2/src/utils/enums.dart';
import 'package:howapp2/src/viewmodels/main_events_viewmodel.dart';
import 'package:howapp2/src/views/main_events_view.dart';

class ExperiencesView extends ConsumerWidget {
  const ExperiencesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewmodel = ref.watch(mainEventsViewmodelProvider(true));

    if (viewmodel.fetchingEvents == ApiState.pending) {
      return const BannersLoadScaffold();
    }
    return BannersLoadedScaffold(viewmodel: viewmodel);
  }
}
