import 'user_model.dart';

class ApplicationState {
  static final ApplicationState initialState = ApplicationState(null, null);

  late final UserModel? currentUser;
  final String? currentTripId;
  bool get hasCompleteProfile => currentUser?.customData != null;

  ApplicationState(this.currentUser, this.currentTripId);
}
