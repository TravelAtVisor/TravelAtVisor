import 'custom_user_data.dart';

class UserModel {
  final String userId;
  final String email;
  final CustomUserData? customData;

  UserModel(this.userId, this.email, this.customData);
}
