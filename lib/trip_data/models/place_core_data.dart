import 'package:flutter/material.dart';

class PlaceCoreData {
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
    if (photos == null) return <String>{};

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
