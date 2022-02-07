import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationState {
  static const AuthenticationState initialState =
      AuthenticationState(null, false);
  final User? currentUser;
  final bool hasCompleteProfile;

  const AuthenticationState(this.currentUser, this.hasCompleteProfile);
}
