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
      _applicationStateEmitter.stream;

  void _setState(ApplicationState state) {
    currentApplicationState = state;
    _applicationStateEmitter.add(state);
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

    _setState(applicationState);
  }

  @override
  Future<void> deleteActivityAsync(String tripId, String activityId) async {
    await _functionsDataService.deleteActivityAsync(
      tripId,
      activityId,
    );

    final newTrips =
        currentApplicationState.currentUser!.customData!.trips.map((e) {
      if (e.tripId != tripId) return e;

      final newActivities =
          e.activities.where((a) => a.activityId != activityId).toList();

      return Trip(tripId, e.title, e.begin, e.end, e.companions, newActivities,
          e.tripDesign);
    }).toList();

    final userModel = currentApplicationState.currentUser!;
    final newCustomData = CustomUserData(
        userModel.customData!.nickname,
        userModel.customData!.fullName,
        userModel.customData!.photoUrl,
        userModel.customData!.biography,
        newTrips,
        userModel.customData!.friends);

    _setState(
      ApplicationState(
        UserModel(
          userModel.userId,
          userModel.email,
          newCustomData,
        ),
        currentApplicationState.currentTripId,
      ),
    );
  }

  @override
  Future<void> deleteTripAsync(String tripId) async {
    await Future.wait([
      _functionsDataService.deleteTripAsync(
        tripId,
      ),
      _storageDataService.deleteCustomTripDesign(tripId),
    ]);

    final userModel = currentApplicationState.currentUser!;
    final newCustomData = CustomUserData(
        userModel.customData!.nickname,
        userModel.customData!.fullName,
        userModel.customData!.photoUrl,
        userModel.customData!.biography,
        userModel.customData!.trips
            .where((element) => element.tripId != tripId)
            .toList(),
        userModel.customData!.friends);

    _setState(
      ApplicationState(
        UserModel(
          userModel.userId,
          userModel.email,
          newCustomData,
        ),
        currentApplicationState.currentTripId,
      ),
    );
  }

  @override
  Future<void> addActivityAsync(String tripId, Activity activity) async {
    await _functionsDataService.addActivityAsync(
      tripId,
      activity,
    );

    final newTrips =
        currentApplicationState.currentUser!.customData!.trips.map((e) {
      if (e.tripId != tripId) return e;

      final newActivities = [
        ...e.activities,
        activity,
      ];

      return Trip(
        tripId,
        e.title,
        e.begin,
        e.end,
        e.companions,
        newActivities,
        e.tripDesign,
      );
    }).toList();

    final userModel = currentApplicationState.currentUser!;
    final newCustomData = CustomUserData(
        userModel.customData!.nickname,
        userModel.customData!.fullName,
        userModel.customData!.photoUrl,
        userModel.customData!.biography,
        newTrips,
        userModel.customData!.friends);

    _setState(
      ApplicationState(
        UserModel(
          userModel.userId,
          userModel.email,
          newCustomData,
        ),
        currentApplicationState.currentTripId,
      ),
    );
  }

  @override
  Future<void> setTripAsync(Trip trip) async {
    final isLocalDesignUrl = File(trip.tripDesign).existsSync();

    final newDesignPath = await _storageDataService.updateCustomTripDesign(
        trip.tripId, isLocalDesignUrl ? trip.tripDesign : null);

    await _functionsDataService.setTripAsync(
      Trip(
        trip.tripId,
        trip.title,
        trip.begin,
        trip.end,
        trip.companions,
        trip.activities,
        isLocalDesignUrl ? newDesignPath! : trip.tripDesign,
      ),
    );

    final newTrips = [
      ...currentApplicationState.currentUser!.customData!.trips
          .where((element) => element.tripId != trip.tripId),
      trip,
    ];

    final userModel = currentApplicationState.currentUser!;
    final newCustomData = CustomUserData(
        userModel.customData!.nickname,
        userModel.customData!.fullName,
        userModel.customData!.photoUrl,
        userModel.customData!.biography,
        newTrips,
        userModel.customData!.friends);

    _setState(
      ApplicationState(
        UserModel(
          userModel.userId,
          userModel.email,
          newCustomData,
        ),
        currentApplicationState.currentTripId,
      ),
    );
  }

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
  Future<void> updateUserProfileAsync(CustomUserData customUserData) async {
    final userId = _authenticationDataService.currentUser!.uid;

    final isLocalPhotoUrl = customUserData.photoUrl != null
        ? File(customUserData.photoUrl!).existsSync()
        : true;

    if (isLocalPhotoUrl) {
      final photoUrl = await _storageDataService.updateProfilePicture(
          userId, customUserData.photoUrl);
      customUserData.photoUrl = photoUrl;
    }

    await _functionsDataService.updateCustomUserData(customUserData);

    final userModel = currentApplicationState.currentUser!;

    _setState(
      ApplicationState(
        UserModel(
          userModel.userId,
          userModel.email,
          customUserData,
        ),
        currentApplicationState.currentTripId,
      ),
    );
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

  @override
  void setActiveTripId(String tripId) {
    _setState(ApplicationState(
      currentApplicationState.currentUser,
      tripId,
    ));
  }

  @override
  Future<void> addFriend(String friendUserId) async {
    await _functionsDataService.addFriend(friendUserId);

    final userModel = currentApplicationState.currentUser!;

    _setState(
      ApplicationState(
        UserModel(
          userModel.userId,
          userModel.email,
          CustomUserData(
              userModel.customData!.nickname,
              userModel.customData!.fullName,
              userModel.customData!.photoUrl,
              userModel.customData!.biography,
              userModel.customData!.trips, [
            ...userModel.customData!.friends,
            friendUserId,
          ]),
        ),
        currentApplicationState.currentTripId,
      ),
    );
  }

  @override
  Future<void> addFriendToTripAsync(String tripId, String friendUserId) async {
    await _functionsDataService.addFriendToTripAsync(tripId, friendUserId);

    final userModel = currentApplicationState.currentUser!;

    _setState(
      ApplicationState(
        UserModel(
          userModel.userId,
          userModel.email,
          CustomUserData(
            userModel.customData!.nickname,
            userModel.customData!.fullName,
            userModel.customData!.photoUrl,
            userModel.customData!.biography,
            userModel.customData!.trips.map((t) {
              if (t.tripId != tripId) return t;
              return Trip(
                tripId,
                t.title,
                t.begin,
                t.end,
                [
                  ...t.companions,
                  friendUserId,
                ],
                t.activities,
                t.tripDesign,
              );
            }).toList(),
            userModel.customData!.friends,
          ),
        ),
        currentApplicationState.currentTripId,
      ),
    );
  }

  @override
  Future<CustomUserData> getForeignProfileAsync(String foreignUserId) =>
      _functionsDataService.getForeignProfileAsync(foreignUserId);

  @override
  Future<void> removeFriend(String friendUserId) async {
    await _functionsDataService.removeFriend(friendUserId);

    final userModel = currentApplicationState.currentUser!;
    _setState(
      ApplicationState(
        UserModel(
          userModel.userId,
          userModel.email,
          CustomUserData(
            userModel.customData!.nickname,
            userModel.customData!.fullName,
            userModel.customData!.photoUrl,
            userModel.customData!.biography,
            userModel.customData!.trips,
            userModel.customData!.friends
                .where((element) => element != friendUserId)
                .toList(),
          ),
        ),
        currentApplicationState.currentTripId,
      ),
    );
  }

  @override
  Future<void> removeFriendFromTripAsync(
      String tripId, String friendUserId) async {
    await _functionsDataService.removeFriendFromTripAsync(tripId, friendUserId);

    final userModel = currentApplicationState.currentUser!;
    _setState(
      ApplicationState(
        UserModel(
          userModel.userId,
          userModel.email,
          CustomUserData(
            userModel.customData!.nickname,
            userModel.customData!.fullName,
            userModel.customData!.photoUrl,
            userModel.customData!.biography,
            userModel.customData!.trips.map((e) {
              if (e.tripId != tripId) return e;
              return Trip(
                tripId,
                e.title,
                e.begin,
                e.end,
                e.companions
                    .where((element) => element != friendUserId)
                    .toList(),
                e.activities,
                e.tripDesign,
              );
            }).toList(),
            userModel.customData!.friends,
          ),
        ),
        currentApplicationState.currentTripId,
      ),
    );
  }

  @override
  Future<List<UserSuggestion>> searchUsersAsync(String query) =>
      _functionsDataService.searchUsersAsync(query);

  @override
  Future<List<UserSuggestion>> getFriends(List<String> friendUserIds) =>
      _functionsDataService.getFriends(friendUserIds);
}
