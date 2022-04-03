import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/trip_module/pages/new_trip.page.dart';
import 'package:travel_atvisor/trip_module/trip.data_service.dart';

import '../../shared_module/models/trip.dart';
import 'scroll_progress_indicator.dart';
import 'package:intl/intl.dart';

class TripChooserCarousel extends StatefulWidget {
  final void Function(Trip activeTrip) onActiveTripChanged;
  final List<Trip> trips;
  const TripChooserCarousel({
    Key? key,
    required this.onActiveTripChanged,
    required this.trips,
  }) : super(key: key);

  @override
  State<TripChooserCarousel> createState() => _TripChooserCarouselState();
}

class _TripChooserCarouselState extends State<TripChooserCarousel> {
  int currentTripIndex = 0;

  @override
  Widget build(BuildContext context) {
    widget.onActiveTripChanged(widget.trips[currentTripIndex]);
    return Column(
      children: [
        CarouselSlider(
          items: widget.trips.map((e) => TripCard(trip: e)).toList(),
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: MediaQuery.of(context).size.height * 0.19,
            viewportFraction: 0.93,
            onPageChanged: (index, _) => setState(() {
              currentTripIndex = index;
            }),
          ),
        ),
        ScrollProgressIndicator(
          elementCount: widget.trips.length,
          currentElement: currentTripIndex,
        ),
      ],
    );
  }
}

class TripCard extends StatelessWidget {
  final Trip trip;
  const TripCard({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd. MMMM');
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.19,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            image: DecorationImage(
              image: NetworkImage(trip.tripDesign),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Opacity(
                      opacity: 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${formatter.format(trip.begin)} bis ${formatter.format(trip.end)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewTrip(
                                      currentTrip: trip,
                                    ),
                                  ),
                                ),
                                icon: const Icon(Icons.edit),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () async {
                                  LoadingOverlay.show(context);
                                  await context
                                      .read<TripDataService>()
                                      .deleteTripAsync(trip.tripId);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          trip.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
