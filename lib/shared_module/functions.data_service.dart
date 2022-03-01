import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:travel_atvisor/shared_module/models/trip.dart';
import 'package:travel_atvisor/shared_module/models/activity.dart';
import 'package:travel_atvisor/activity_module/models/place_core_data.dart';
import 'package:travel_atvisor/activity_module/models/locality_suggestion.dart';
import 'package:travel_atvisor/activity_module/models/extended_place_data.dart';

import '../activity_module/activity.data_service.dart';
import '../trip_module/trip.data_service.dart';
import 'models/custom_user_data.dart';

class FunctionsDataService implements TripDataservice, ActivityDataService {
  final FirebaseFunctions _functions;

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

  FunctionsDataService(this._functions);

  @override
  Future<void> deleteActivityAsync(
          String userId, String tripId, String activityId) =>
      _deleteActivity.call();

  @override
  Future<void> deleteTripAsync(String userId, String tripId) =>
      _deleteTrip.call();

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

  @override
  Future<void> setActivityAsync(
          String userId, String tripId, Activity activity) =>
      _setActivity.call();

  @override
  Future<void> setTripAsync(String userId, Trip trip) => _setTrip.call();

  Future<CustomUserData?> getCustomUserData() async {
    final data = await _getCustomUserData.call();

    if (data.data == null) return null;

    return CustomUserData.fromDynamic(data.data);
  }

  Future<bool> isUsernameAvailable(String username) async {
    final data = await _isUserNameAvailable.call({"username": username});
    return data.data;
  }

  Future<void> updateCustomUserData(CustomUserData customUserData) async {
    final data = customUserData.toMap();
    await _updateCustomUserData.call(data);
  }
}
