import 'package:travel_atvisor/user_module/models/user_suggestion.dart';

import '../shared_module/models/authentication_result.dart';
import '../shared_module/models/custom_user_data.dart';

abstract class UserDataService {
  Future<CustomUserData?> getCustomUserDataByIdAsync();
  Future<bool> isUsernameAvailableAsync(String username);
  Future<AuthenticationResult> signUpAsync(
      {required String email, required String password});
  Future<AuthenticationResult> signInAsync(
      {required String email, required String password});
  Future<AuthenticationResult> signInWithGoogleAsync();
  Future<void> updateUserProfileAsync(CustomUserData customUserData);
  Future<void> signOutAsync();
  Future<void> addFriend(String friendUserId);
  Future<void> removeFriend(String friendUserId);
  Future<CustomUserData> getForeignProfileAsync(String foreignUserId);
  Future<List<UserSuggestion>> searchUsersAsync(String query);
  Future<List<UserSuggestion>> getFriends(List<String> friendUserIds);
}
