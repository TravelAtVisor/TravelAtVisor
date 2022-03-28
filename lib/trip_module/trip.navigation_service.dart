import 'package:flutter/material.dart';
import 'package:travel_atvisor/shared_module/models/trip.dart';

abstract class TripNavigationService {
  Future<void> pushAddActivityScreen(BuildContext context, String tripID);
  Future<void> pushActivityDetailScreen(
      BuildContext context, String foursquareId);
  Future<void> pushAddFriendScreen(BuildContext context, Trip trip);
}
