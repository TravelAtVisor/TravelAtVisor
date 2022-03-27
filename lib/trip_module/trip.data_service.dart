import 'package:travel_atvisor/shared_module/models/friend.dart';

import '../shared_module/models/trip.dart';

abstract class TripDataService {
  Future<void> setTripAsync(Trip trip);
  Future<void> deleteTripAsync(String tripId);
  Future<void> deleteActivityAsync(String tripId, String activityId);
  Future<void> addFriendToTripAsync(String tripId, String friendUserId);
  Future<void> removeFriendFromTripAsync(String tripId, String friendUserId);
  Future<List<Friend>> getFriends(List<String> friendUserIds);

  void setActiveTripId(String tripId);
}
