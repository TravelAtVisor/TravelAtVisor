import 'package:flutter/material.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';

import '../shared_module/models/activity.dart';

abstract class TripNavigationService {

  Future<void> pushActivityDetailScreen(
      BuildContext context, String foursquareId,
      {Activity? activity});
  Future<UserSuggestion?> pushAddFriendScreen(
      BuildContext context, List<UserSuggestion> friendsToAdd);
  void pushAddTripPage(BuildContext context);
}
