import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_atvisor/activity_module/activity.data_service.dart';
import 'package:travel_atvisor/shared_module/authentication.data_service.dart';
import 'package:travel_atvisor/shared_module/functions.data_service.dart';
import 'package:travel_atvisor/shared_module/models/user_model.dart';
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

  ApplicationState currentApplicationState = ApplicationState.initialState;
  final StreamController<ApplicationState> _applicationStateEmitter =
      StreamController<ApplicationState>();
  Stream<ApplicationState> get applicationState =>
      _applicationStateEmitter.stream.map((event) {
        print("State update");
        print(event.currentUser);
        return event;
      });

  DataService(FirebaseFunctions functions, FirebaseStorage storage,
      FirebaseAuth authentication) {
    _functionsDataService = FunctionsDataService(functions);
    _storageDataService = StorageDataService(storage);
    _authenticationDataService =
        AuthenticationDataService(authentication, refreshCurrentUser);
  }

  Future<void> refreshCurrentUser(User? currentUser) async {
    var applicationState = currentApplicationState;

    if (currentUser == null) {
      applicationState = ApplicationState(null, applicationState.currentTripId);
    } else {
      applicationState = ApplicationState(
        UserModel(
          currentUser.uid,
          currentUser.email!,
          await getCustomUserDataByIdAsync(),
        ),
        currentApplicationState.currentTripId,
      );
    }

    _applicationStateEmitter.add(applicationState);
  }

  @override
  Future<void> deleteActivityAsync(String tripId, String activityId) =>
      _useStateMutatingFunction(() => _functionsDataService.deleteActivityAsync(
            tripId,
            activityId,
          ));

  @override
  Future<void> deleteTripAsync(String tripId) =>
      _useStateMutatingFunction(() => _functionsDataService.deleteTripAsync(
            tripId,
          ));

  @override
  Future<void> addActivityAsync(String tripId, Activity activity) =>
      _useStateMutatingFunction(() => _functionsDataService.addActivityAsync(
            tripId,
            activity,
          ));

  @override
  Future<void> setTripAsync(Trip trip) =>
      _useStateMutatingFunction(() => _functionsDataService.setTripAsync(
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
  Future<CustomUserData?> getCustomUserDataByIdAsync() =>
      _functionsDataService.getCustomUserData();

  @override
  Future<bool> isUsernameAvailableAsync(String username) =>
      _functionsDataService.isUsernameAvailable(username);

  @override
  Future<void> updateUserProfileAsync(CustomUserData customUserData) =>
      _useStateMutatingFunction(() async {
        final userId = _authenticationDataService.currentUser!.uid;
        final photoUrl = await _storageDataService.updateProfilePicture(
            userId, customUserData.photoUrl);
        customUserData.photoUrl = photoUrl;
        return _functionsDataService.updateCustomUserData(customUserData);
      });

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
    await refreshCurrentUser(_authenticationDataService.currentUser);

    return result;
  }

  @override
  void setActiveTripId(String tripId) {
    _applicationStateEmitter.add(ApplicationState(
      currentApplicationState.currentUser,
      tripId,
    ));
  }
}
