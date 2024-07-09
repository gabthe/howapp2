import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectTypeOfProfile extends ConsumerWidget {
  const SelectTypeOfProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed('createPersonalProfile');
                  },
                  child: const Text('Quero participar de eventos'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed('createCommercialProfile');
                  },
                  child: const Text('Quero publicar eventos'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
