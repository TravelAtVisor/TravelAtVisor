import 'package:flutter/material.dart';
import 'package:travel_atvisor/activity_module/pages/locality_chooser_page.dart';
import 'package:travel_atvisor/activity_module/pages/place_details.dart';
import 'package:travel_atvisor/global.navigation_service.dart';
import 'package:travel_atvisor/trip_module/pages/new_trip.page.dart';
import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';
import 'package:travel_atvisor/user_module/pages/add_friend.page.dart';

class NavigationService
    implements TripNavigationService, GlobalNavigationService {
  @override
  Future<void> pushAddActivityScreen(BuildContext context, String tripId) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LocalityChooserPage(tripId: tripId)));
  }

  @override
  Future<void> pushActivityDetailScreen(
      BuildContext context, String foursquareId) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlaceDetails(foursquareId: foursquareId)));
  }

  @override
  void pushAddTripPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewTrip()));
  }

  @override
  Future<UserSuggestion?> pushAddFriendScreen(
      BuildContext context, List<UserSuggestion> friendsToAdd) async {
    return await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddFriendPage(friendsToAdd: friendsToAdd)));
  }
}
