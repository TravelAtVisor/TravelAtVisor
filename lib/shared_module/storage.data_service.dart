import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageDataService {
  static const String _defaultProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/images.jpeg?alt=media&token=c61daa6c-ea9f-4361-8074-768fc2961283";
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

    return url ?? defaultValue;
  }
}
