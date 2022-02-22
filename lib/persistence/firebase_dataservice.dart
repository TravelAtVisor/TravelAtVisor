import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:travel_atvisor/user_data/models/activity.dart';

import '../user_data/behaviour/authentication_dataservice.dart';
import '../user_data/models/custom_user_data.dart';
import '../user_data/models/trip.dart';

class FirebaseDataservice implements AuthenticationDataService {
  static const String _defaultProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/images.jpeg?alt=media&token=c61daa6c-ea9f-4361-8074-768fc2961283";
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirebaseDataservice(this._firestore, this._storage);

  @override
  Future<CustomUserData?> getCustomUserDataByIdAsync(String userId) async {
    final snapshot = await _firestore.collection("users").doc(userId).get();
    if (!snapshot.exists) return null;

    final data = snapshot.data()!;
    return CustomUserData.fromDynamic(data);
  }

  @override
  Future<void> updateCustomUserDataAsync(
      String userId, CustomUserData customUserData) async {
    final photoUrl =
        await _updateProfilePicture(userId, customUserData.photoUrl);
    customUserData.photoUrl = photoUrl;
    final data = customUserData.toMap();

    await _firestore.collection("users").doc(userId).set(data);
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

  // This method should ideally be executed server-side as the client-side
  // implementation requires all user records to be available.
  // This means, that the whole user database can be accesed via the publicly
  // available Firestore REST-API
  @override
  Future<bool> isUsernameAvailableAsync(String username) async {
    final snapshot = await _firestore
        .collection("users")
        .where("nickname", isEqualTo: username)
        .get();

    return snapshot.size == 0;
  }

  @override
  Future<void> deleteTripAsync(String userId, String tripId) {
    final updateRequest = {
      "trips": {
        "09a37987-fd56-4416-8b39-e6895a75166e": FieldValue.delete(),
      }
    };

    return _firestore.collection("users").doc(userId).update(updateRequest);
  }

  @override
  Future<void> setTripAsync(String userId, Trip trip) {
    final ref = _firestore.collection("users").doc(userId);
    final rawData = trip.toMap();

    return ref.set({
      "trips": {
        trip.tripId: rawData,
      }
    }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteActivityAsync(
      String userId, String tripId, String activityId) {
    return _firestore.collection("users").doc(userId).update({
      "trips": {
        tripId: {
          "activities": {
            activityId: FieldValue.delete(),
          }
        }
      }
    });
  }

  @override
  Future<void> setActivityAsync(
      String userId, String tripId, Activity activity) {
    final ref = _firestore.collection("users").doc(userId);
    final rawData = activity.toMap();

    return ref.set({
      "trips": {
        tripId: {
          "activities": {
            activity.activityId: rawData,
          }
        }
      }
    }, SetOptions(merge: true));
  }
}
