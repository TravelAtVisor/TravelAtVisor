import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/trip_module/views/trip_chooser_carousel.dart';
import '../../shared_module/models/activity.dart';
import '../../shared_module/models/trip.dart';
import '../../shared_module/views/companions_friends.dart';
import '../trip.data_service.dart';
import 'package:intl/intl.dart';
import '../trip.navigation_service.dart';

class TripList extends StatelessWidget {
  final List<Trip> trips;
  final Trip? currentTrip;

  const TripList({
    Key? key,
    required this.trips,
    required this.currentTrip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentTrip == null) {
      context.read<TripDataService>().setActiveTripId(trips.first.tripId);
    }
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        TripChooserCarousel(
          onActiveTripChanged: (currentTrip) {
            if (this.currentTrip?.tripId != currentTrip.tripId) {
              context
                  .read<TripDataService>()
                  .setActiveTripId(currentTrip.tripId);
            }
          },
          trips: trips,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.03,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: const CompanionsFriends(header: 'Begleiter', addPerson: true),
        ),
        ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment(0.0, 0.65),
              end: Alignment(0.0, 1.0),
              colors: [Colors.black, Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.03),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: currentTrip != null
                  ? buildTripActiviesList(currentTrip!)
                  : null),
        ),
      ],
    );
  }

  Widget buildTripActiviesList(Trip trip) {
    final groupedByDay = trip.activities.fold(<DateTime, List<Activity>>{},
        (Map<DateTime, List<Activity>> previousValue, element) {
      final day = DateTime(element.timestamp.year, element.timestamp.month,
          element.timestamp.day);
      if (previousValue.containsKey(day)) {
        previousValue[day]!.add(element);
      } else {
        previousValue[day] = [element];
      }
      return previousValue;
    });

    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => TripDayRow(
        activities: groupedByDay.values.elementAt(index),
        tripId: trip.tripId,
      ),
      itemCount: groupedByDay.length,
    );
  }
}

class TripDayRow extends StatelessWidget {
  final List<Activity> activities;
  final String tripId;

  const TripDayRow({
    Key? key,
    required this.activities,
    required this.tripId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
                DateFormat('dd.MM.yyyy').format(activities.first.timestamp),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          ...activities.map(
            (e) => TripActivityRow(
              activity: e,
              tripId: tripId,
            ),
          ),
          Opacity(
              opacity: 0.2,
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1.5,
                indent: 20,
                endIndent: 20,
              ))
        ],
      ),
    );
  }
}

class TripActivityRow extends StatelessWidget {
  final Activity activity;
  final String tripId;

  const TripActivityRow(
      {Key? key, required this.activity, required this.tripId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedTextColor: Colors.black,
      collapsedIconColor: Colors.black,
      title: Row(children: [
        Image.network(
          activity.photoUrl,
          height: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.25,
          fit: BoxFit.contain,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.035,
        ),
        Flexible(
          child: Text(activity.title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              )),
        )
      ]),
      children: [
        Text(activity.description ?? "Keine Beschreibung verfügbar."),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => context
                  .read<TripNavigationService>()
                  .pushActivityDetailScreen(context, activity.foursquareId),
              icon: const Icon(Icons.info),
              color: Colors.grey,
              iconSize: MediaQuery.of(context).size.width * 0.07,
            ),
            IconButton(
              onPressed: () => context
                  .read<TripDataService>()
                  .deleteActivityAsync(tripId, activity.activityId),
              icon: const Icon(Icons.delete),
              color: Colors.grey,
              iconSize: MediaQuery.of(context).size.width * 0.07,
            ),
          ],
        )
      ],
    );
  }
}
