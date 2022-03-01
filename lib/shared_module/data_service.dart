import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_atvisor/activity_module/activity.data_service.dart';
import 'package:travel_atvisor/shared_module/authentication.data_service.dart';
import 'package:travel_atvisor/shared_module/functions.data_service.dart';
import 'package:travel_atvisor/shared_module/storage.data_service.dart';

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
  late final FunctionsDataService _functionsDataService;
  late final StorageDataService _storageDataService;
  late final AuthenticationDataService _authenticationDataService;

  final StreamController<User?> _manualAppStateEmitter =
      StreamController<User?>();

  Stream<ApplicationState> get applicationState =>
      _manualAppStateEmitter.stream.asyncMap((currentUser) async {
        final customData = currentUser != null
            ? await getCustomUserDataByIdAsync(currentUser.uid)
            : null;

        return ApplicationState(currentUser, customData);
      });

  DataService(FirebaseFunctions functions, FirebaseStorage storage,
      FirebaseAuth authentication) {
    _functionsDataService = FunctionsDataService(functions);
    _storageDataService = StorageDataService(storage);
    _authenticationDataService = AuthenticationDataService(
      authentication,
      _manualAppStateEmitter.add,
    );
  }

  @override
  Future<void> deleteActivityAsync(
          String userId, String tripId, String activityId) =>
      _useStateMutatingFunction(() => _functionsDataService.deleteActivityAsync(
            userId,
            tripId,
            activityId,
          ));

  @override
  Future<void> deleteTripAsync(String userId, String tripId) =>
      _useStateMutatingFunction(() => _functionsDataService.deleteTripAsync(
            userId,
            tripId,
          ));

  @override
  Future<void> setActivityAsync(
          String userId, String tripId, Activity activity) =>
      _useStateMutatingFunction(() => _functionsDataService.setActivityAsync(
            userId,
            tripId,
            activity,
          ));

  @override
  Future<void> setTripAsync(String userId, Trip trip) =>
      _useStateMutatingFunction(() => _functionsDataService.setTripAsync(
            userId,
            trip,
          ));

  @override
  Future<ExtendedPlaceData> getPlaceDetailsAsync(String foursquareId) =>
      _functionsDataService.getPlaceDetailsAsync(foursquareId);

  @override
  Future<List<LocalitySuggestion>> searchLocalitiesAsync(
          String input, String sessionKey) =>
      _functionsDataService.searchLocalitiesAsync(input, sessionKey);

  @override
  Future<List<PlaceCoreData>> searchPlacesAsync(
          String input, String locality) =>
      _functionsDataService.searchPlacesAsync(input, locality);

  @override
  Future<CustomUserData?> getCustomUserDataByIdAsync(String userId) =>
      _functionsDataService.getCustomUserData();

  @override
  Future<bool> isUsernameAvailableAsync(String username) =>
      _functionsDataService.isUsernameAvailable(username);

  @override
  Future<void> updateUserProfileAsync(CustomUserData customUserData) async {
    final userId = _authenticationDataService.currentUser!.uid;
    final photoUrl = await _storageDataService.updateProfilePicture(
        userId, customUserData.photoUrl);
    customUserData.photoUrl = photoUrl;
    return _functionsDataService.updateCustomUserData(customUserData);
  }

  @override
  Future<AuthenticationResult> signUpAsync(
          {required String email, required String password}) =>
      _authenticationDataService.signUpAsync(email: email, password: password);

  @override
  Future<AuthenticationResult> signInAsync(
          {required String email, required String password}) =>
      _authenticationDataService.signInAsync(email: email, password: password);

  @override
  Future<AuthenticationResult> signInWithGoogleAsync() =>
      _authenticationDataService.signInWithGoogleAsync();

  @override
  Future<void> signOutAsync() => _authenticationDataService.signOutAsync();

  Future<TResult> _useStateMutatingFunction<TResult>(
      Future<TResult> Function() mutatingFunction) async {
    final result = await mutatingFunction();

    _manualAppStateEmitter.add(_authenticationDataService.currentUser);

    return result;
  }
}
