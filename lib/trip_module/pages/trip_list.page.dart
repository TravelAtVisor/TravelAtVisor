import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/views/full_width_button.dart';

import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';
import 'package:travel_atvisor/trip_module/views/trip_list.dart';

class TripListPage extends StatefulWidget {
  const TripListPage({Key? key}) : super(key: key);

  @override
  _TripListPageState createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, state, child) {
        final navigationService = context.read<TripNavigationService>();
        final trips = state.currentUser!.customData!.trips;
        trips.sort((a, b) => a.begin.compareTo(b.begin));

        final t = trips
            .where((element) => element.tripId == state.currentTripId)
            .toList();
        final currentTrip = t.isNotEmpty ? t.single : null;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: Center(
            child: trips.isNotEmpty
                ? TripList(
                    trips: trips,
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Willkommen beim Travel@Visor. Es ist Zeit zu verreisen. Los, lege hier deine erste Reise an!",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FullWidthButton(
                              text: "Verreisen",
                              onPressed: () =>
                                  navigationService.pushAddTripPage(context),
                              isElevated: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
