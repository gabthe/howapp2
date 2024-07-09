import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:howapp2/src/services/firebase_auth_service.dart';
import 'package:howapp2/src/views/navigator_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: decorationGradient(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('Home')),
              ElevatedButton(
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
