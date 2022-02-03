import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_atvisor/authentication/authentication_result.dart';

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;

  AuthenticationProvider(this.firebaseAuth);

  Stream<User?> get authState => firebaseAuth.idTokenChanges();

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up!";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Unknown error occured";
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

  Future<void> signOut() async {
    await firebaseAuth.signOut();
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
