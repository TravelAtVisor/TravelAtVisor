import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageDataService {
  static const String _defaultProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/ph_profile.png?alt=media&token=9273044a-565d-4699-9290-8910d30d9c43";
  final FirebaseStorage _storage;

  StorageDataService(this._storage);

  Future<String> updateProfilePicture(
      String userId, String? profilePicturePath) async {
    final ref = _storage.ref("users/$userId");
    return (await _setOrDeleteImage(
        ref, profilePicturePath, _defaultProfilePicture))!;
  }

  Future<String?> updateCustomTripDesign(
      String tripId, String? customTripDesignPath) {
    final ref = _storage.ref("trip_designs/$tripId");
    return _setOrDeleteImage(ref, customTripDesignPath, null);
  }

  Future<String?> _setOrDeleteImage(
      Reference ref, String? imagePath, String? defaultValue) async {
    String? url;

    if (imagePath != null) {
      await ref.putFile(File(imagePath));
      url = await ref.getDownloadURL();
    } else {
      await _deleteRef(ref);
    }

    return url ?? defaultValue;
  }

  Future<void> deleteCustomTripDesign(String tripId) {
    final ref = _storage.ref("trip_designs/$tripId");
    return _deleteRef(ref);
  }

  Future<void> _deleteRef(Reference ref) async {
    try {
      await ref.delete();
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
}
