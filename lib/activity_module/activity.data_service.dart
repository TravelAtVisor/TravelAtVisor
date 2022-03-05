import 'package:travel_atvisor/activity_module/models/place_categories.dart';

import '../shared_module/models/activity.dart';
import 'models/extended_place_data.dart';
import 'models/locality_suggestion.dart';
import 'models/place_core_data.dart';

abstract class ActivityDataService {
  Future<List<LocalitySuggestion>> searchLocalitiesAsync(
      String input, String sessionKey);
  Future<List<PlaceCoreData>> searchPlacesAsync(
      String input, String locality, PlaceCategory? category);
  Future<ExtendedPlaceData> getPlaceDetailsAsync(String foursquareId);
  Future<void> deleteActivityAsync(String tripId, String activityId);
  Future<void> addActivityAsync(String tripId, Activity activity);
}
