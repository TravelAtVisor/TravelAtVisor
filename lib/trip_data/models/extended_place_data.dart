import 'package:flutter/material.dart';

import '../../utils/mappers.dart';
import 'place_core_data.dart';

class ExtendedPlaceData extends PlaceCoreData {
  final String? description;
  final String? phoneNumber;
  final String? website;
  final SocialMediaLinks socialMediaLinks;
  final List<OpeningHour>? openingHours;
  final List<OpeningHour>? popularHours;
  final int? priceRating;
  final double? rating;
  final Address? address;

  ExtendedPlaceData(
      {required String foursquareId,
      required String name,
      required Set<int> categories,
      required Set<String> photoUrls,
      required this.description,
      required this.phoneNumber,
      required this.website,
      required this.socialMediaLinks,
      required this.openingHours,
      required this.popularHours,
      required this.priceRating,
      this.rating,
      this.address})
      : super(
            foursquareId: foursquareId,
            name: name,
            categories: categories,
            photoUrls: photoUrls);

  static ExtendedPlaceData fromDynamic(dynamic data) {
    final baseData = PlaceCoreData.fromDynamic(data, null);
    final regularHours = data["hours"]?["regular"] as List<dynamic>?;
    final popularHours = data["hours_popular"] as List<dynamic>?;

    return ExtendedPlaceData(
      foursquareId: data["fsq_id"],
      name: baseData.name,
      categories: baseData.categories,
      photoUrls: baseData.photoUrls,
      description: data["description"],
      phoneNumber: data["tel"],
      website: data["website"],
      socialMediaLinks: SocialMediaLinks.fromDynamic(data["social_media"]),
      openingHours:
          regularHours?.map((e) => OpeningHour.fromDynamic(e)).toList(),
      popularHours:
          popularHours?.map((e) => OpeningHour.fromDynamic(e)).toList(),
      priceRating: DynamicMappers.getInt(data["price"]),
      rating: DynamicMappers.getDouble(data["rating"]),
    );
  }
}

class OpeningHour {
  final Day day;
  final TimeOfDay opening;
  final TimeOfDay closing;

  OpeningHour(this.day, this.opening, this.closing);

  static OpeningHour fromDynamic(dynamic openingHour) {
    return OpeningHour(
      DynamicMappers.getDay(openingHour["day"]),
      DynamicMappers.getTimeOfDay(openingHour["open"]),
      DynamicMappers.getTimeOfDay(openingHour["close"]),
    );
  }
}

class Address {
  final String formatted;
  final String postcode;
  final String address;
  final String locality;

  Address(
      {required this.formatted,
      required this.postcode,
      required this.address,
      required this.locality});

  static Address fromDynamix(dynamic data) {
    throw UnimplementedError();
  }
}

enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class SocialMediaLinks {
  final String? facebookId;
  final String? instagram;
  final String? twitter;

  SocialMediaLinks({this.facebookId, this.instagram, this.twitter});

  static SocialMediaLinks fromDynamic(dynamic links) {
    return SocialMediaLinks(
        facebookId: links["facebook_id"],
        instagram: links["instagram"],
        twitter: links["twitter"]);
  }
}
