import '../shared_module/models/custom_user_data.dart';

abstract class UserDataService {
  Future<CustomUserData?> getCustomUserDataByIdAsync(String userId);
  Future<void> updateCustomUserDataAsync(
      String userId, CustomUserData customUserData);

  Future<bool> isUsernameAvailableAsync(String username);
}
