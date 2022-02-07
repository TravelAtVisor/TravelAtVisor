import 'package:travel_atvisor/authentication/custom_user_data.dart';

abstract class AuthenticationDataService {
  Future<CustomUserData?> getCustomUserDataByIdAsync(String userId);
}
