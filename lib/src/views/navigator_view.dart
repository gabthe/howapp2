import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:howapp2/src/services/user_service.dart';
import 'package:howapp2/src/views/experiences_view.dart';
import 'package:howapp2/src/views/main_events_view.dart';
import 'package:howapp2/src/views/profile_view.dart';
import 'package:howapp2/src/views/search_view.dart';

final screens = [
  const MainEventsView(),
  const ExperiencesView(),
  // const SearchView(),
  const ProfileView(
    isMyProfile: true,
  ),
];

final bottomNavigationBarKeyProvider = StateProvider<GlobalKey>((ref) {
  return GlobalKey();
});

final _screenIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final _pageControllerProvider = StateProvider<PageController>((ref) {
  return PageController();
});

class NavigatorView extends ConsumerWidget {
  const NavigatorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userService = ref.watch(userServiceProvider);
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: ref.watch(_pageControllerProvider),
        children: screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color.fromARGB(255, 36, 0, 0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 36, 0, 0),
          key: ref.watch(bottomNavigationBarKeyProvider),
          currentIndex: ref.watch(_screenIndexProvider),
          onTap: (index) {
            ref.read(_screenIndexProvider.notifier).state = index;
            ref.watch(_pageControllerProvider).animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.ease,
                );
          },
          items: const [
            BottomNavigationBarItem(
              label: 'Destaques',
              icon: Icon(Icons.highlight),
            ),
            BottomNavigationBarItem(
              label: 'Experiencias',
              icon: Icon(Icons.public),
            ),
            // BottomNavigationBarItem(
            //   label: 'Explorar',
            //   icon: Icon(Icons.search),
            // ),
            BottomNavigationBarItem(
              label: 'Perfil',
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration decorationGradient() {
  int contant = 6;
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, contant * 0, 0, 0),
        Color.fromARGB(255, contant, 0, 0),
        Color.fromARGB(255, contant * 2, 0, 0),
        Color.fromARGB(255, contant * 3, 0, 0),
        Color.fromARGB(255, contant * 4, 0, 0),
        Color.fromARGB(255, contant * 5, 0, 0),
        Color.fromARGB(255, contant * 6, 0, 0),
      ],
      stops: const [
        0.65,
        0.7,
        0.75,
        0.8,
        0.85,
        0.9,
        1.0,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}
