import '../shared_module/models/trip.dart';

abstract class TripDataService {
  Future<void> setTripAsync(Trip trip);
  Future<void> deleteTripAsync(String tripId);
  Future<void> deleteActivityAsync(String tripId, String activityId);

  void setActiveTripId(String tripId);
}
