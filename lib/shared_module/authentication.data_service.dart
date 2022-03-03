import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/authentication_result.dart';
import 'utils/mappers.dart';

class AuthenticationDataService {
  final _googleSignIn = GoogleSignIn();
  final FirebaseAuth authentication;

  AuthenticationDataService(
      this.authentication, void Function(User? record) onAuthStateChanged) {
    authentication.idTokenChanges().listen(onAuthStateChanged);
  }

  Future<AuthenticationResult> signUpAsync(
      {required String email, required String password}) async {
    try {
      await authentication.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      return StringMappers.getAuthenticationResult(e.code);
    }
  }

  Future<AuthenticationResult> signInAsync(
      {required String email, required String password}) async {
    try {
      await authentication.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      return StringMappers.getAuthenticationResult(e.code);
    }
  }

  Future<AuthenticationResult> signInWithGoogleAsync() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return AuthenticationResult.canceled;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await authentication.signInWithCredential(credential);

      return AuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      return StringMappers.getAuthenticationResult(e.code);
    } on PlatformException catch (e) {
      if (e.message == "com.google.GIDSignIn") {}
      return AuthenticationResult.unexpected;
    }
  }

  Future<void> signOutAsync() async {
    await authentication.signOut();
  }

  User? get currentUser => authentication.currentUser;
}
