import 'package:flutter/material.dart';

class PlaceCoreData {
  static const String defaultImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/travelatvisor.appspot.com/o/no-image.jpg?alt=media&token=8b0b0ecb-cc43-4831-b80c-2929f81c5853";
  final String foursquareId;
  final String name;
  final Set<int> categories;
  final Set<String> photoUrls;

  PlaceCoreData(
      {required this.foursquareId,
      required this.name,
      required this.categories,
      required this.photoUrls});

  static PlaceCoreData fromDynamic(dynamic data, Size? imageSize) {
    return PlaceCoreData(
        foursquareId: data["fsq_id"],
        name: data["name"],
        categories: _parseCategories(data["categories"]),
        photoUrls: _parsePhotos(data["photos"], imageSize));
  }

  static Set<int> _parseCategories(List<dynamic> categories) =>
      categories.map((c) {
        final categoryId = c["id"] as int;
        return categoryId - (categoryId % 1000);
      }).toSet();

  static Set<String> _parsePhotos(List<dynamic>? photos, Size? size) {
    if (photos == null || photos.isEmpty) return <String>{defaultImageUrl};

    final sizeModifier = size != null
        ? "${size.width.toInt()}x${size.height.toInt()}"
        : "original";

    return photos.map((p) {
      final prefix = p["prefix"] as String;
      final suffix = p["suffix"] as String;
      return "$prefix$sizeModifier$suffix";
    }).toSet();
  }
}
