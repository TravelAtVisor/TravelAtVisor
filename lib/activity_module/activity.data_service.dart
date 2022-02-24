import '../shared_module/models/activity.dart';
import 'models/extended_place_data.dart';
import 'models/locality_suggestion.dart';
import 'models/place_core_data.dart';

abstract class ActivityDataService {
  Future<List<LocalitySuggestion>> searchLocalitiesAsync(
      String input, String sessionKey);
  Future<List<PlaceCoreData>> searchPlacesAsync(String input, String locality);
  Future<ExtendedPlaceData> getPlaceDetailsAsync(String foursquareId);
  Future<void> deleteActivityAsync(
      String userId, String tripId, String activityId);
  Future<void> setActivityAsync(
      String userId, String tripId, Activity activity);
}
