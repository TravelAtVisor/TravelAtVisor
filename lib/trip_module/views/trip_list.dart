import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/trip_module/views/trip_chooser_carousel.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';
import '../../shared_module/models/activity.dart';
import '../../shared_module/models/trip.dart';
import '../../shared_module/views/companions_friends.dart';
import '../trip.data_service.dart';
import 'package:intl/intl.dart';
import '../trip.navigation_service.dart';

class TripList extends StatefulWidget {
  final List<Trip> trips;
  final Trip? currentTrip;

  const TripList({
    Key? key,
    required this.trips,
    required this.currentTrip,
  }) : super(key: key);

  @override
  State<TripList> createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  List<UserSuggestion>? friendsAvailable;

  Future<void> ensureFriends(
      TripDataService tripDataService, List<String> friendUserIds) async {
    if (friendsAvailable == null) {
      tripDataService.getFriends(friendUserIds).then((value) => setState((() {
            friendsAvailable = value;
          })));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripDataService = context.read<TripDataService>();
    if (widget.currentTrip == null) {
      context
          .read<TripDataService>()
          .setActiveTripId(widget.trips.first.tripId);
    }

    ensureFriends(tripDataService,
        context.watch<ApplicationState>().currentUser!.customData!.friends);

    return widget.currentTrip == null
        ? const LoadingOverlay()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TripChooserCarousel(
                  onActiveTripChanged: (currentTrip) {
                    if (widget.currentTrip?.tripId != currentTrip.tripId) {
                      context
                          .read<TripDataService>()
                          .setActiveTripId(currentTrip.tripId);
                    }
                  },
                  trips: widget.trips,
                ),
              ),
              if (friendsAvailable != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CompanionsFriends(
                        header: 'Begleiter',
                        canAddPerson: true,
                        addFriend: () async {
                          final newFriend = await context
                              .read<TripNavigationService>()
                              .pushAddFriendScreen(
                                  context,
                                  friendsAvailable!
                                      .where((element) => !widget
                                          .currentTrip!.companions
                                          .contains(element.userId))
                                      .toList());
                          if (newFriend != null) {
                            tripDataService.addFriendToTripAsync(
                                widget.currentTrip!.tripId, newFriend.userId);
                          }
                        },
                        friends: widget.currentTrip!.companions
                            .map((e) => friendsAvailable!
                                .where((element) => element.userId == e)
                                .single)
                            .toList(),
                        removeFriend: (oldFriendId) =>
                            tripDataService.removeFriendFromTripAsync(
                                widget.currentTrip!.tripId, oldFriendId),
                      ),
                    ),
                  ),
                ),
              if (widget.currentTrip != null)
                buildTripActiviesList(widget.currentTrip!),
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

    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) => TripDayCard(
          activities: groupedByDay.values.elementAt(index),
          tripId: trip.tripId,
        ),
        itemCount: groupedByDay.length,
        shrinkWrap: true,
      ),
    );
  }
}

class TripDayCard extends StatelessWidget {
  final List<Activity> activities;
  final String tripId;

  const TripDayCard({
    Key? key,
    required this.activities,
    required this.tripId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      DateFormat('E, dd.MM.yyyy')
                          .format(activities.first.timestamp),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                      )),
                ),
              ),
              ...activities.map(
                (e) => TripActivityRow(
                  activity: e,
                  tripId: tripId,
                ),
              ),
            ],
          ),
        ),
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
      leading: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(
              activity.photoUrl,
            ),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ),
      title: Text(
        activity.title,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(activity.description ?? "Keine Beschreibung verfügbar."),
        ),
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
