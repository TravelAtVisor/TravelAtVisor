import 'package:firebase_auth/firebase_auth.dart';

import 'custom_user_data.dart';
import 'user_model.dart';

class ApplicationState {
  static final ApplicationState initialState = ApplicationState(null, null);
  late final UserModel? currentUser;
  late final bool hasCompleteProfile;

  ApplicationState(User? baseData, CustomUserData? customData) {
    hasCompleteProfile = baseData != null && customData != null;

    currentUser = baseData != null
        ? UserModel(baseData.uid, baseData.email!, customData)
        : null;
  }
}
