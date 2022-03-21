import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.19,
        child: Column(
          children: [
            ListTile(
              title: Text(
                formatter.format(trip.begin) +
                    " - " +
                    formatter.format(trip.end),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.035),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0.1),
              child: Text(
                trip.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
