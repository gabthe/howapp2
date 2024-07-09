import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:howapp2/src/services/firebase_auth_service.dart';

class SearchView extends ConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            ref.watch(firebaseAuthServiceProvider).signOut();
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
