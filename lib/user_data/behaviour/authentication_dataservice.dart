import 'package:travel_atvisor/user_data/models/activity.dart';

import '../models/custom_user_data.dart';
import '../models/trip.dart';

abstract class AuthenticationDataService {
  Future<CustomUserData?> getCustomUserDataByIdAsync(String userId);
  Future<void> updateCustomUserDataAsync(
      String userId, CustomUserData customUserData);

  Future<bool> isUsernameAvailableAsync(String username);

  Future<void> setTripAsync(String userId, Trip trip);
  Future<void> deleteTripAsync(String userId, String tripId);
  Future<void> setActivityAsync(
      String userId, String tripId, Activity activity);
  Future<void> deleteActivityAsync(
      String userId, String tripId, String activityId);
}
