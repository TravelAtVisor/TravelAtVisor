import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_atvisor/authentication/authentication_dataservice.dart';
import 'package:travel_atvisor/authentication/authentication_result.dart';
import 'package:travel_atvisor/authentication/authentication_state.dart';
import 'package:travel_atvisor/authentication/custom_user_data.dart';
import 'dart:async';

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  final AuthenticationDataService _dataService;
  final StreamController<User?> _manualAuthStateEmitter =
      StreamController<User?>();

  AuthenticationProvider(this.firebaseAuth, this._dataService) {
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
      return AuthenticationResult.successIncompleteProfile;
    } on FirebaseAuthException catch (e) {
      return parseErrorCode(e.code);
    }
  }

  Future<AuthenticationResult> signIn(
      {required String email, required String password}) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return isProfileCompleted(credential.user!)
          ? AuthenticationResult.success
          : AuthenticationResult.successIncompleteProfile;
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

  bool isProfileCompleted(User user) {
    return user.displayName != null &&
        user.email != null &&
        user.emailVerified &&
        user.photoURL != null;
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
}
