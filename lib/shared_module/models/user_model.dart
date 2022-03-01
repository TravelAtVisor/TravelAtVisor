import 'package:firebase_auth/firebase_auth.dart';

import 'custom_user_data.dart';

class UserModel {
  final String userId;
  final String email;
  final CustomUserData? customData;

  UserModel(this.userId, this.email, this.customData);

  static UserModel fromUser(User user, CustomUserData? customUserData) {
    return UserModel(user.uid, user.email!, customUserData);
  }
}
