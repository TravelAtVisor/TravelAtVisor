import 'package:travel_atvisor/user_module/models/user_suggestion.dart';

import '../shared_module/models/trip.dart';

abstract class TripDataService {
  Future<void> setTripAsync(Trip trip);
  Future<void> deleteTripAsync(String tripId);
  Future<void> deleteActivityAsync(String tripId, String activityId);

  Future<void> removeFriendFromTripAsync(String tripId, String friendUserId);
  Future<List<UserSuggestion>> getFriends(List<String> friendUserIds);

  void setActiveTripId(String tripId);
}
