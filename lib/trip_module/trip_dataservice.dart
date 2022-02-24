import '../shared_module/models/trip.dart';
import 'models/extended_place_data.dart';
import 'models/locality_suggestion.dart';
import 'models/place_core_data.dart';

abstract class TripDataservice {
  Future<List<LocalitySuggestion>> searchLocalitiesAsync(
      String input, String sessionKey);
  Future<List<PlaceCoreData>> searchPlacesAsync(String input, String locality);
  Future<ExtendedPlaceData> getPlaceDetailsAsync(String foursquareId);
  Future<void> setTripAsync(String userId, Trip trip);
  Future<void> deleteTripAsync(String userId, String tripId);
}
