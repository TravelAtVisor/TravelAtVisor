import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_atvisor/authentication/custom_user_data.dart';
import 'package:travel_atvisor/authentication/user_model.dart';

class AuthenticationState {
  static final AuthenticationState initialState =
      AuthenticationState(null, null);
  late final UserModel? currentUser;
  late final bool hasCompleteProfile;

  AuthenticationState(User? baseData, CustomUserData? customData) {
    hasCompleteProfile = baseData != null && customData != null;

    currentUser = baseData != null
        ? UserModel(baseData.uid, baseData.uid, customData)
        : null;
  }
}
