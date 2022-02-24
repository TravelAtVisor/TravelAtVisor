import '../shared_module/models/activity.dart';

abstract class ActivityDataService {
  Future<void> deleteActivityAsync(
      String userId, String tripId, String activityId);
  Future<void> setActivityAsync(
      String userId, String tripId, Activity activity);
}
