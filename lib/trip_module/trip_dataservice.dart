import 'package:travel_atvisor/trip_data/models/extended_place_data.dart';
import 'package:travel_atvisor/trip_data/models/locality_suggestion.dart';
import 'package:travel_atvisor/trip_data/models/place_core_data.dart';

abstract class TripDataservice {
  Future<List<LocalitySuggestion>> searchLocalitiesAsync(
      String input, String sessionKey);
  Future<List<PlaceCoreData>> searchPlacesAsync(String input, String locality);
  Future<ExtendedPlaceData> getPlaceDetailsAsync(String foursquareId);
}
