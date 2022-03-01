import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_atvisor/activity_module/activity.data_service.dart';

import '../activity_module/models/extended_place_data.dart';
import '../activity_module/models/locality_suggestion.dart';
import '../activity_module/models/place_core_data.dart';
import '../trip_module/trip.data_service.dart';
import '../user_module/user.data_service.dart';
import 'models/activity.dart';
import 'models/authentication_result.dart';
import 'models/authentication_state.dart';
import 'models/custom_user_data.dart';
import 'models/trip.dart';

class DataService
    implements UserDataService, TripDataservice, ActivityDataService {
  static const String _defaultProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/images.jpeg?alt=media&token=c61daa6c-ea9f-4361-8074-768fc2961283";
  final FirebaseFunctions _functions;
  final FirebaseStorage _storage;
  final FirebaseAuth firebaseAuth;

  late final _getCustomUserData = _functions.httpsCallable("getCustomUserData");
  late final _updateCustomUserData =
      _functions.httpsCallable("updateCustomUserData");
  late final _isUserNameAvailable =
      _functions.httpsCallable("isUsernameAvailable");
  late final _setTrip = _functions.httpsCallable("setTrip");
  late final _deleteTrip = _functions.httpsCallable("deleteTrip");
  late final _setActivity = _functions.httpsCallable("setActivity");
  late final _deleteActivity = _functions.httpsCallable("deleteActivity");
  late final _searchLocalityProxy =
      _functions.httpsCallable("searchLocalityProxy");
  late final _searchPlaceProxy = _functions.httpsCallable("searchPlaceProxy");
  late final _getPlaceDetailsProxy =
      _functions.httpsCallable("getPlaceDetailsProxy");

  final StreamController<User?> _manualAuthStateEmitter =
      StreamController<User?>();

  DataService(this._functions, this._storage, this.firebaseAuth) {
    firebaseAuth
        .idTokenChanges()
        .listen((event) => _manualAuthStateEmitter.add(event));
  }

  @override
  Future<void> deleteActivityAsync(
      String userId, String tripId, String activityId) {
    return _deleteActivity.call({"tripId": tripId, "activityId": activityId});
  }

  @override
  Future<void> deleteTripAsync(String userId, String tripId) async {
    await _deleteTrip.call({"tripId": tripId});
  }

  @override
  Future<CustomUserData?> getCustomUserDataByIdAsync(String userId) async {
    final data = await _getCustomUserData.call();

    if (data.data == null) return null;

    return CustomUserData.fromDynamic(data.data);
  }

  @override
  Future<bool> isUsernameAvailableAsync(String username) async {
    final data = await _isUserNameAvailable.call({"username": username});
    return data.data;
  }

  @override
  Future<void> setActivityAsync(
      String userId, String tripId, Activity activity) {
    return _setActivity.call({
      "tripId": tripId,
      "activityId": activity.activityId,
      "activity": activity.toMap()
    });
  }

  @override
  Future<void> setTripAsync(String userId, Trip trip) {
    return _setTrip.call({"tripId": trip.tripId, "trip": trip.toMap()});
  }

  @override
  Future<void> updateCustomUserDataAsync(
      String userId, CustomUserData customUserData) async {
    final photoUrl =
        await _updateProfilePicture(userId, customUserData.photoUrl);
    customUserData.photoUrl = photoUrl;
    final data = customUserData.toMap();

    await _updateCustomUserData.call(data);
  }

  Future<String> _updateProfilePicture(
      String userId, String? profilePicturePath) async {
    String? url;

    if (profilePicturePath != null) {
      final ref = _storage.ref("users/$userId");
      await ref.putFile(File(profilePicturePath));
      url = await ref.getDownloadURL();
    } else {
      try {
        await _storage.ref("users/$userId").delete();
      } on FirebaseException catch (e) {
        // Unfortunately FlutterFire does not support a way to determine
        // whether a file exists so we will ignore a possible exception
        // in this place but log it to the console if in debug mode.
        if (e.code != "object-not-found") {
          rethrow;
        }

        if (kDebugMode) {
          print(e);
        }
      }
    }

    return url ?? _defaultProfilePicture;
  }

  @override
  Future<ExtendedPlaceData> getPlaceDetailsAsync(String foursquareId) async {
    final response =
        await _getPlaceDetailsProxy.call({"foursquareId": foursquareId});

    return ExtendedPlaceData.fromDynamic(response.data);
  }

  @override
  Future<List<LocalitySuggestion>> searchLocalitiesAsync(
      String input, String sessionKey) async {
    final response = await _searchLocalityProxy
        .call({"input": input, "sessionToken": sessionKey});

    final dynamicData = response.data["predictions"] as List<dynamic>;

    return dynamicData.map((e) => LocalitySuggestion.fromDynamic(e)).toList();
  }

  @override
  Future<List<PlaceCoreData>> searchPlacesAsync(
      String input, String locality) async {
    final response =
        await _searchPlaceProxy.call({"input": input, "locality": locality});

    final dynamicData = response.data["results"] as List<dynamic>;

    return dynamicData
        .map((e) => PlaceCoreData.fromDynamic(e, const Size(130, 130)))
        .toList();
  }

  Stream<AuthenticationState> get authState =>
      _manualAuthStateEmitter.stream.asyncMap((currentUser) async {
        final customData = currentUser != null
            ? await getCustomUserDataByIdAsync(currentUser.uid)
            : null;

        return AuthenticationState(currentUser, customData);
      });

  @override
  Future<AuthenticationResult> signUpAsync(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      return parseErrorCode(e.code);
    }
  }

  @override
  Future<AuthenticationResult> signInAsync(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthenticationResult.success;
    } on FirebaseAuthException catch (e) {
      return parseErrorCode(e.code);
    }
  }

  @override
  Future<AuthenticationResult> signInWithGoogleAsync() async {
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

  @override
  Future<void> signOutAsync() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> updateUserProfileAsync(CustomUserData customUserData) async {
    await updateCustomUserDataAsync(
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
}
