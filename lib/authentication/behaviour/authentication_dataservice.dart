import 'package:travel_atvisor/authentication/models/custom_user_data.dart';

abstract class AuthenticationDataService {
  Future<CustomUserData?> getCustomUserDataByIdAsync(String userId);
  Future<void> updateCustomUserDataAsync(
      String userId, CustomUserData customUserData);

  Future<bool> isUsernameAvailableAsync(String username);
}
