import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:howapp2/src/models/event.dart';
import 'package:howapp2/src/models/profile_resume.dart';
import 'package:howapp2/src/repositories/events_repository.dart';
import 'package:howapp2/src/services/user_service.dart';

var interestedFutureProvider = FutureProvider.family
    .autoDispose<List<ProfileResume>, String>((ref, eventId) async {
  try {
    var result = await ref.watch(eventsRepoProvider).getInterestedList(eventId);
    return result;
  } catch (e) {
    print(e);

    rethrow;
  }
});

class InterestedInEventView extends ConsumerWidget {
  final Event event;
  const InterestedInEventView({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var interestListFuture = ref.watch(interestedFutureProvider(event.id));
    var userService = ref.watch(userServiceProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de interessados'),
        ),
        body: interestListFuture.when(
          data: (data) {
            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var profileResume = data[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // GoRouter.of(context).pushNamed('viewProfile', extra: {
                          //   'isMyProfile': false,
                          //   'profileId': profileResume.id,
                          // });
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey[700],
                              ),
                              child: profileResume.photoUrl == null
                                  ? Center(
                                      child: Text(profileResume.displayName[0]),
                                    )
                                  : Center(
                                      child: CachedNetworkImage(
                                        imageUrl: profileResume.photoUrl!,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profileResume.displayName),
                                Text('@${profileResume.username}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ))
              ],
            );
          },
          loading: () {
            return const Center(child: Text('Carregando ...'));
          },
          error: (error, stackTrace) {
            return Text('$error');
          },
        ));
  }
}

class InterestedWidget extends StatelessWidget {
  const InterestedWidget({
    super.key,
    required this.myId,
    required this.user,
  });

  final String myId;
  final ProfileResume user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: myId == user.id
          ? null
          : () {
              GoRouter.of(context).pushNamed('viewProfile', extra: {
                'isMyProfile': false,
                'profileId': user.id,
              });
            },
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey,
            ),
            child: user.photoUrl != null
                ? CachedNetworkImage(imageUrl: user.photoUrl!)
                : Center(
                    child: Text(
                      user.displayName[0],
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.displayName),
              Text(user.username),
            ],
          ),
        ],
      ),
    );
  }
}
