import 'package:flutter/material.dart';
import 'package:travel_atvisor/activity_module/pages/locality_chooser_page.dart';
import 'package:travel_atvisor/activity_module/pages/place_details.dart';
import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';

class NavigationService implements TripNavigationService {
  @override
  Future<void> pushAddActivityScreen(BuildContext context, String tripId) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LocalityChooserPage(tripId: tripId)));
  }

  @override
  Future<void> pushActivityDetailScreen(BuildContext context, String foursquareId) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlaceDetails(foursquareId: foursquareId)));
  }
}
