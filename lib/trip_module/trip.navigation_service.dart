import 'package:flutter/material.dart';
import 'package:travel_atvisor/shared_module/models/trip.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';

abstract class TripNavigationService {
  Future<void> pushAddActivityScreen(BuildContext context, String tripID);
  Future<void> pushActivityDetailScreen(
      BuildContext context, String foursquareId);
  Future<UserSuggestion?> pushAddFriendScreen(
      BuildContext context, List<UserSuggestion> friendsToAdd);
}
