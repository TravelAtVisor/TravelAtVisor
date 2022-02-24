import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_atvisor/user_data/models/activity.dart';
import 'package:travel_atvisor/user_data/models/trip.dart';
import '../user_data/models/authentication_result.dart';
import '../user_data/models/authentication_state.dart';
import '../user_data/models/custom_user_data.dart';
import '../user_module/authentication_dataservice.dart';

class UserDataProvider {
  final FirebaseAuth firebaseAuth;
  final AuthenticationDataService _dataService;
  final StreamController<User?> _manualAuthStateEmitter =
      StreamController<User?>();

  UserDataProvider(this.firebaseAuth, this._dataService) {
    firebaseAuth
        .idTokenChanges()
        .listen((event) => _manualAuthStateEmitter.add(event));
  }

  Stream<AuthenticationState> get authState =>
      _manualAuthStateEmitter.stream.asyncMap((currentUser) async {
        final customData = currentUser != null
            ? await _dataService.getCustomUserDataByIdAsync(currentUser.uid)
            : null;

        return AuthenticationState(currentUser, customData);
      });

  Future<AuthenticationResult> signUp(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      return parseErrorCode(e.code);
    }
  }

  Future<AuthenticationResult> signIn(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      return parseErrorCode(e.code);
    }
  }

  Future<AuthenticationResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await firebaseAuth.signInWithCredential(credential);
      return AuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      return parseErrorCode(e.code);
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> updateUserProfile(CustomUserData customUserData) async {
    await _dataService.updateCustomUserDataAsync(
        firebaseAuth.currentUser!.uid, customUserData);
    _manualAuthStateEmitter.add(firebaseAuth.currentUser);
  }

  AuthenticationResult parseErrorCode(String code) {
    switch (code) {
      case "user-not-found":
        return AuthenticationResult.unkownUser;
      case "invalid-email":
        return AuthenticationResult.invalidMail;
      case "wrong-password":
        return AuthenticationResult.wrongPassword;
      default:
        return AuthenticationResult.unexpected;
    }
  }

  Future<bool> isUsernameAvailable(String username) {
    return _dataService.isUsernameAvailableAsync(username);
  }

  Future<void> addOrUpdateTrip(Trip trip) {
    return _dataService.setTripAsync(firebaseAuth.currentUser!.uid, trip);
  }

  Future<void> deleteTrip(String tripId) {
    return _dataService.deleteTripAsync(firebaseAuth.currentUser!.uid, tripId);
  }

  Future<void> addOrUpdateActivity(String tripId, Activity activity) {
    return _dataService.setActivityAsync(
        firebaseAuth.currentUser!.uid, tripId, activity);
  }

  Future<void> deleteActivity(String tripId, String activityId) {
    return _dataService.deleteActivityAsync(
        firebaseAuth.currentUser!.uid, tripId, activityId);
  }
}
