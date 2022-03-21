import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/models/custom_user_data.dart';
import 'package:travel_atvisor/shared_module/views/full_width_button.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';
import '../../shared_module/models/trip.dart';
import 'edit_user_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final double titleImageHeight = 200;
  final double profileImageHeight = 120;

  @override
  Widget build(BuildContext context) {
    final userDataService = context.read<UserDataService>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Profil'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EditUserScreen()));
              },
            )
          ],
        ),
        body: Consumer<ApplicationState>(builder: (context, state, _) {
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: profileImageHeight / 2 + 5,
                    child: CircleAvatar(
                      radius: profileImageHeight / 2,
                      foregroundImage:
                          state.currentUser!.customData!.photoUrl != null
                              ? Image.network(
                                      state.currentUser!.customData!.photoUrl!)
                                  .image
                              : null,
                      backgroundImage:
                          const AssetImage("assets/ph_profile.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.currentUser!.customData!.fullName,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "@${state.currentUser!.customData!.nickname}",
                          style: const TextStyle(color: Colors.lightBlue),
                        )
                      ],
                    ),
                  ),
                  ProfileStatisticsViewer(
                      customUserData: state.currentUser!.customData!),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  BiographyViewer(
                      biography: state.currentUser!.customData!.biography),
                  FullWidthButton(
                    text: "Abmelden",
                    onPressed: () => userDataService.signOutAsync(),
                    isElevated: false,
                  ),
                ],
              ),
            ),
          );
        }));
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
