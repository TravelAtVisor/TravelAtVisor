import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';
import '../activity_module/pages/search_activity.dart';

class NavigationService implements TripNavigationService{
  @override
  Future<void> pushAddActivityScreen(BuildContext context, String tripId) {
    return Navigator.of(context).push(MaterialPageRoute(builder:(context) => SearchActivity(tripId: tripId)));
  }

}