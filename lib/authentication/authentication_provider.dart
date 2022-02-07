import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_atvisor/authentication/authentication_result.dart';

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;

  AuthenticationProvider(this.firebaseAuth);

  Stream<User?> get authState => firebaseAuth.idTokenChanges();

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
