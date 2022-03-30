import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_atvisor/activity_module/activity.data_service.dart';
import 'package:travel_atvisor/activity_module/models/place_categories.dart';
import 'package:travel_atvisor/shared_module/authentication.data_service.dart';
import 'package:travel_atvisor/shared_module/functions.data_service.dart';
import 'package:travel_atvisor/shared_module/models/user_model.dart';
import 'package:travel_atvisor/shared_module/storage.data_service.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';

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
    implements UserDataService, TripDataService, ActivityDataService {
  late final FunctionsDataService _functionsDataService;
  late final StorageDataService _storageDataService;
  late final AuthenticationDataService _authenticationDataService;

  ApplicationState currentApplicationState = ApplicationState.initialState;
  final StreamController<ApplicationState> _applicationStateEmitter =
      StreamController<ApplicationState>();
  Stream<ApplicationState> get applicationState =>
      _applicationStateEmitter.stream.map((event) {
        currentApplicationState = event;
        return event;
      });

  Future<TResult> _useStateMutatingFunction<TResult>(
      Future<TResult> Function() mutatingFunction) async {
    final result = await mutatingFunction();
    await refreshCurrentUser(_authenticationDataService.currentUser);

    return result;
  }

  @override
  Future<CustomUserData?> getCustomUserDataByIdAsync() =>
      _functionsDataService.getCustomUserData();

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
          String input, String locality, PlaceCategory? category) =>
      _functionsDataService.searchPlacesAsync(input, locality, category);

  @override
  Future<bool> isUsernameAvailableAsync(String username) =>
      _functionsDataService.isUsernameAvailable(username);

  @override
  Future<void> updateUserProfileAsync(CustomUserData customUserData) =>
      _useStateMutatingFunction(() async {
        final userId = _authenticationDataService.currentUser!.uid;

        final isLocalPhotoUrl = customUserData.photoUrl != null
            ? File(customUserData.photoUrl!).existsSync()
            : true;

        // As uploading the photo is time expensive, only upload it local files
        if (isLocalPhotoUrl) {
          final photoUrl = await _storageDataService.updateProfilePicture(
              userId, customUserData.photoUrl);
          customUserData.photoUrl = photoUrl;
        }

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

  @override
  void setActiveTripId(String tripId) {
    _applicationStateEmitter.add(ApplicationState(
      currentApplicationState.currentUser,
      tripId,
    ));
  }

  @override
  Future<void> addFriend(String friendUserId) => _useStateMutatingFunction(
      () => _functionsDataService.addFriend(friendUserId));

  @override
  Future<void> addFriendToTripAsync(String tripId, String friendUserId) =>
      _useStateMutatingFunction(() =>
          _functionsDataService.addFriendToTripAsync(tripId, friendUserId));

  @override
  Future<CustomUserData> getForeignProfileAsync(String foreignUserId) =>
      _functionsDataService.getForeignProfileAsync(foreignUserId);

  @override
  Future<void> removeFriend(String friendUserId) => _useStateMutatingFunction(
      () => _functionsDataService.removeFriend(friendUserId));

  @override
  Future<void> removeFriendFromTripAsync(String tripId, String friendUserId) =>
      _useStateMutatingFunction(() => _functionsDataService
          .removeFriendFromTripAsync(tripId, friendUserId));

  @override
  Future<List<UserSuggestion>> searchUsersAsync(String query) =>
      _functionsDataService.searchUsersAsync(query);

  @override
  Future<List<UserSuggestion>> getFriends(List<String> friendUserIds) =>
      _functionsDataService.getFriends(friendUserIds);
}
