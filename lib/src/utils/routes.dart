import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/services/firebase_auth_service.dart';
import 'package:howapp2/src/views/event_view.dart';
import 'package:howapp2/src/views/experiences_view.dart';
import 'package:howapp2/src/views/home_view.dart';
import 'package:howapp2/src/views/interested_in_event_view.dart';
import 'package:howapp2/src/views/navigator_view.dart';
import 'package:howapp2/src/views/profile_creation/create_commercial_profile_view.dart';
import 'package:howapp2/src/views/profile_creation/create_personal_profile_view.dart';
import 'package:howapp2/src/views/profile_creation/select_city_view.dart';
import 'package:howapp2/src/views/profile_creation/select_type_of_profile_view.dart';
import 'package:howapp2/src/views/profile_view.dart';
import 'package:howapp2/src/views/sign_in_view.dart';
import 'package:howapp2/src/views/sign_up_view.dart';
import 'package:howapp2/src/views/splash_screen_view.dart';

class AuthNotifier extends ChangeNotifier {
  final FirebaseAuthService authService;

  AuthNotifier(this.authService) {
    authService.authStateChanges.listen((User? user) {
      notifyListeners();
    });
  }
}

final authNotifierProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  return AuthNotifier(authService);
});

final routesProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splashScreen',
    routes: [
      GoRoute(
        name: 'splashScreen',
        path: '/splashScreen',
        builder: (context, state) => const SplashScreenView(),
      ),
      GoRoute(
        name: 'signIn',
        path: '/signIn',
        builder: (context, state) => const SignInView(),
      ),
      GoRoute(
        name: 'signUp',
        path: '/signUp',
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        name: 'navigator',
        path: '/navigator',
        builder: (context, state) => const NavigatorView(),
      ),
      GoRoute(
        name: 'createProfile',
        path: '/createProfile',
        builder: (context, state) => const SelectTypeOfProfile(),
      ),
      GoRoute(
        name: 'createCommercialProfile',
        path: '/createCommercialProfile',
        builder: (context, state) => const CreateCommercialProfile(),
      ),
      GoRoute(
        name: 'createPersonalProfile',
        path: '/createPersonalProfile',
        builder: (context, state) => const CreatePersonalProfileView(),
      ),
      GoRoute(
        name: 'selectCity',
        path: '/selectCity',
        builder: (context, state) => const SelectCityView(),
      ),
      GoRoute(
        name: 'experiences',
        path: '/experiences',
        builder: (context, state) => const ExperiencesView(),
      ),
      GoRoute(
        name: 'eventView',
        path: '/eventView',
        builder: (context, state) {
          Event event = state.extra as Event;
          return EventView(event: event);
        },
      ),
      GoRoute(
        name: 'viewProfile',
        path: '/viewProfile',
        builder: (context, state) {
          Map<String, dynamic> params = state.extra as Map<String, dynamic>;
          return ProfileView(
            isMyProfile: params['isMyProfile'],
            profileId: params['profileId'],
          );
        },
      ),
      GoRoute(
        name: 'interestedInEvent',
        path: '/interestedInEvent',
        builder: (context, state) {
          Event event = state.extra as Event;
          return InterestedInEventView(
            event: event,
          );
        },
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authService.getCurrentUser() != null;

      if (!isLoggedIn && state.fullPath == '/navigator') {
        return '/signIn';
      }
      if (!isLoggedIn && state.fullPath == '/splashScreen') {
        return '/signIn';
      }
      if (isLoggedIn && state.fullPath == '/splashScreen') {
        return '/navigator';
      }

      return null;
    },
    refreshListenable: authNotifier,
  );
});
