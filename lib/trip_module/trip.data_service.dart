import '../shared_module/models/trip.dart';

abstract class TripDataservice {
  Future<void> setTripAsync(String userId, Trip trip);
  Future<void> deleteTripAsync(String userId, String tripId);
}
