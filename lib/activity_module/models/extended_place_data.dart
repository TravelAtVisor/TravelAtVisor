import 'package:flutter/material.dart';
import 'package:travel_atvisor/activity_module/models/place_categories.dart';

import '../../shared_module/utils/mappers.dart';
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
  final Geocodes geocodes;

  ExtendedPlaceData(
      {required String foursquareId,
      required String name,
      required Set<PlaceCategory> categories,
      required Set<String> photoUrls,
      required this.description,
      required this.phoneNumber,
      required this.website,
      required this.socialMediaLinks,
      required this.openingHours,
      required this.popularHours,
      required this.priceRating,
      required this.geocodes,
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
        geocodes: Geocodes.fromDynamic(data["geocodes"]["main"]),
        address: Address.fromDynamic(data["location"]));
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

  static Address? fromDynamic(dynamic data) {
    if (data == null) return null;
    return Address(
        formatted: data["formatted_address"],
        postcode: data["postcode"],
        address: data["address"],
        locality: data["locality"]);
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

class Geocodes {
  final double latitude;
  final double longitude;

  Geocodes(this.latitude, this.longitude);

  static Geocodes fromDynamic(dynamic data) {
    return Geocodes(
      DynamicMappers.getDouble(data["latitude"])!,
      DynamicMappers.getDouble(data["longitude"])!,
    );
  }
}
