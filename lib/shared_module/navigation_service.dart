import 'package:flutter/material.dart';
import 'package:travel_atvisor/activity_module/pages/locality_chooser_page.dart';
import 'package:travel_atvisor/global.navigation_service.dart';
import 'package:travel_atvisor/trip_module/pages/new_trip.page.dart';
import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';

class NavigationService
    implements TripNavigationService, GlobalNavigationService {
  @override
  Future<void> pushAddActivityScreen(BuildContext context, String tripId) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LocalityChooserPage(tripId: tripId)));
  }

  @override
  void pushAddTripPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewTrip()));
  }
}
