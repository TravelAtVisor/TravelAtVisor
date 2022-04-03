import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/models/custom_user_data.dart';
import 'package:travel_atvisor/shared_module/utils/mappers.dart';
import 'package:travel_atvisor/shared_module/views/companions_friends.dart';
import 'package:travel_atvisor/shared_module/views/full_width_button.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';
import 'package:travel_atvisor/user_module/pages/search_user.page.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';
import '../../shared_module/models/trip.dart';
import 'edit_user_screen.dart';

class UserScreen extends StatefulWidget {
  final String? userId;

  const UserScreen({Key? key, this.userId}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final double titleImageHeight = 200;
  final double profileImageHeight = 120;

  CustomUserData? customUserData;

  Map<String, UserSuggestion> friends = {};

  bool haveFriendsChanged(List<String> newFriends) {
    final friendWasRemoved =
        friends.values.any((element) => !newFriends.contains(element.userId));
    final friendWasAdded =
        newFriends.any((element) => !friends.containsKey(element));
    return friendWasAdded || friendWasRemoved;
  }

  @override
  Widget build(BuildContext context) {
    final ownCustomData =
        context.watch<ApplicationState>().currentUser!.customData!;
    final dataService = context.read<UserDataService>();
    if (customUserData == null) {
      (widget.userId == null
              ? Future.value(ownCustomData)
              : dataService.getForeignProfileAsync(widget.userId!))
          .then(
        (value) => setState(() {
          customUserData = value;
        }),
      );
    }

    if (haveFriendsChanged(ownCustomData.friends)) {
      if (ownCustomData.friends.isEmpty) {
        setState(() {
          friends = {};
        });
      } else {
        dataService
            .getFriends(ownCustomData.friends)
            .then((value) => setState((() {
                  friends = value.toMap((e) => e.userId, (e) => e);
                })));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: widget.userId == null
            ? const Text('Profil')
            : Text(customUserData?.nickname ?? "Profil"),
        leading: widget.userId == null
            ? IconButton(
                icon: const Icon(
                  Icons.person_search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchUserPage()));
                },
              )
            : null,
        actions: [
          if (widget.userId == null)
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () async {
                final newUserState = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const EditUserScreen()));
                setState(() {
                  customUserData = newUserState;
                });
              },
            ),
          if (widget.userId != null)
            _buildFriendshipButtons(context, ownCustomData),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildFriendshipButtons(BuildContext context, CustomUserData ownData) {
    final isAlreadyAFriend = ownData.friends.contains(widget.userId);
    if (isAlreadyAFriend) {
      return IconButton(
        icon: const Icon(
          Icons.person_remove,
          color: Colors.white,
        ),
        onPressed: () async {
          LoadingOverlay.show(context);
          context.read<UserDataService>().removeFriend(widget.userId!);
          Navigator.pop(context);
        },
      );
    } else {
      return IconButton(
        icon: const Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        onPressed: () async {
          LoadingOverlay.show(context);
          context.read<UserDataService>().addFriend(widget.userId!);
          Navigator.pop(context);
        },
      );
    }
  }

  Widget _buildBody() {
    if (customUserData == null) return const LoadingOverlay();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: profileImageHeight / 2 + 5,
              child: CircleAvatar(
                radius: profileImageHeight / 2,
                foregroundImage: customUserData!.photoUrl != null
                    ? Image.network(customUserData!.photoUrl!).image
                    : null,
                backgroundImage: const AssetImage("assets/ph_profile.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    customUserData!.fullName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "@${customUserData!.nickname}",
                    style: const TextStyle(color: Colors.lightBlue),
                  )
                ],
              ),
            ),
            ProfileStatisticsViewer(customUserData: customUserData!),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            if (widget.userId == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CompanionsFriends(
                    header: "Meine Freunde",
                    canAddPerson: false,
                    friends: friends.values.toList(),
                    addFriend: () {},
                    removeFriend: (userId) =>
                        context.read<UserDataService>().removeFriend(userId),
                  ),
                ),
              ),
            BiographyViewer(biography: customUserData!.biography),
            if (widget.userId == null)
              FullWidthButton(
                text: "Abmelden",
                onPressed: () => context.read<UserDataService>().signOutAsync(),
                isElevated: false,
              ),
          ],
        ),
      ),
    );
  }
}

class BiographyViewer extends StatelessWidget {
  final String? biography;

  const BiographyViewer({
    Key? key,
    required this.biography,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (biography == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Über mich",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(biography!),
      ],
    );
  }
}

class _Statistics {
  late final int tripCount;
  late final int totalDays;
  late final int totalActivities;

  _Statistics takeIntoAccount(Trip trip) {
    return _Statistics(
        totalActivities: totalActivities + trip.activities.length,
        totalDays: totalDays + trip.end.difference(trip.begin).inDays,
        tripCount: tripCount + 1);
  }

  _Statistics({
    required this.tripCount,
    required this.totalActivities,
    required this.totalDays,
  });

  _Statistics.initial() {
    tripCount = 0;
    totalDays = 0;
    totalActivities = 0;
  }
}

class ProfileStatisticsViewer extends StatelessWidget {
  final CustomUserData customUserData;
  const ProfileStatisticsViewer({Key? key, required this.customUserData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statistics = customUserData.trips.fold(_Statistics.initial(),
        (_Statistics accumulator, trip) => accumulator.takeIntoAccount(trip));

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${statistics.tripCount}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              const Text("Reisen")
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${statistics.totalDays}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              const Text("Tage")
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${statistics.totalActivities}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              const Text("Aktivitäten")
            ],
          ),
        ),
      ],
    );
  }
}
