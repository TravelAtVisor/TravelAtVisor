import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/trip_module/views/trip_list.dart';

class TripListPage extends StatefulWidget {
  const TripListPage({Key? key}) : super(key: key);

  @override
  _TripListPageState createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: MediaQuery.of(context).size.height * 0.001,
      ),
      body: Center(
        child: Consumer<ApplicationState>(builder: (context, state, child) {
          final trips = state.currentUser!.customData!.trips;
          trips.sort((a, b) => a.begin.compareTo(b.begin));

          final t = trips
              .where((element) => element.tripId == state.currentTripId)
              .toList();
          final currentTrip = t.isNotEmpty ? t.single : null;

          return trips.isNotEmpty
              ? TripList(
                  currentTrip: currentTrip,
                  trips: trips,
                )
              : Column(
                  children: const [
                    Text(
                        "Willkommen beim Travek@Visor. Es ist Zeit zu verreisen. Los, lege mit dem \"+\" Button deine erste Reise an!")
                  ],
                );
        }),
      ),
    );
  }
}
