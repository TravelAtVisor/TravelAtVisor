import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../user_data/behaviour/authentication_dataservice.dart';
import '../user_data/models/custom_user_data.dart';

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
    return CustomUserData(
        data["nickname"],
        data["fullName"],
        data["photoUrl"] ?? _defaultProfilePicture,
        data["biography"],
        CustomUserData.dummyTrips);
  }

  @override
  Future<void> updateCustomUserDataAsync(
      String userId, CustomUserData customUserData) async {
    final photoUrl =
        await _updateProfilePicture(userId, customUserData.photoUrl);
    final data = {
      "nickname": customUserData.nickname,
      "fullName": customUserData.fullName,
      "photoUrl": photoUrl,
      "biography": customUserData.biography
    };

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
}
