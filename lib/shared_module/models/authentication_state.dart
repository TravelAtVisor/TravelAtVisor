import 'user_model.dart';

class ApplicationState {
  static final ApplicationState initialState =
      ApplicationState(null, null, false);

  late final UserModel? currentUser;
  final String? currentTripId;
  final bool isInitialized;
  bool get isLoggedIn => currentUser != null;
  bool get hasCompleteProfile => currentUser?.customData != null;

  ApplicationState(this.currentUser, this.currentTripId, this.isInitialized);
}
