class PlaceCategory {
  static const artsAndEntertainment = 10000;
  static const businessAndProfessional = 11000;
  static const communityAndGovernment = 12000;
  static const diningAndDrinking = 13000;
  static const event = 14000;
  static const healthAndMedicine = 15000;
  static const landmarksAndOutdoors = 16000;
  static const retail = 17000;
  static const sportsAndReceration = 18000;
  static const travelAndTransportation = 19000;

  static String describe(int category) {
    switch (category) {
      case artsAndEntertainment:
        return "Kunst und Unterhaltung";
      case businessAndProfessional:
        return "Unternehmen";
      case communityAndGovernment:
        return "Einrichtung der öffentlichen Hand";
      case diningAndDrinking:
        return "Restaurant oder Bar";
      case event:
        return "Veranstaltung";
      case healthAndMedicine:
        return "Gesundheit und Medizin";
      case landmarksAndOutdoors:
        return "Sehenswürdigkeiten";
      case retail:
        return "Einkaufsladen";
      case sportsAndReceration:
        return "Sport und Erholung";
      case travelAndTransportation:
        return "Reisen und Transport";

      default:
        throw ArgumentError("category is unknown");
    }
  }
}
