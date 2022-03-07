import 'package:flutter/material.dart';

class PlaceCategory {
  final String displayValue;
  final IconData iconData;
  final int value;

  const PlaceCategory(this.displayValue, this.iconData, this.value);

  static const artsAndEntertainment = PlaceCategory(
    "Kunst und Unterhaltung",
    Icons.theater_comedy,
    10000,
  );
  static const businessAndProfessional = PlaceCategory(
    "Unternehmen",
    Icons.business,
    11000,
  );
  static const communityAndGovernment = PlaceCategory(
    "Einrichtung der öffentlichen Hand",
    Icons.local_police,
    12000,
  );
  static const diningAndDrinking = PlaceCategory(
    "Restaurant oder Bar",
    Icons.liquor,
    13000,
  );
  static const event = PlaceCategory(
    "Veranstaltung",
    Icons.local_activity,
    14000,
  );
  static const healthAndMedicine = PlaceCategory(
    "Gesundheit und Medizin",
    Icons.health_and_safety,
    15000,
  );
  static const landmarksAndOutdoors = PlaceCategory(
    "Sehenswürdigkeiten",
    Icons.park,
    16000,
  );
  static const retail = PlaceCategory(
    "Einkaufsladen",
    Icons.storefront,
    17000,
  );
  static const sportsAndReceration = PlaceCategory(
    "Sport und Erholung",
    Icons.sports,
    18000,
  );
  static const travelAndTransportation = PlaceCategory(
    "Reisen und Transport",
    Icons.directions_bus,
    19000,
  );

  static const categories = {
    10000: artsAndEntertainment,
    11000: businessAndProfessional,
    12000: communityAndGovernment,
    13000: diningAndDrinking,
    14000: event,
    15000: healthAndMedicine,
    16000: landmarksAndOutdoors,
    17000: retail,
    18000: sportsAndReceration,
    19000: travelAndTransportation,
  };
}
