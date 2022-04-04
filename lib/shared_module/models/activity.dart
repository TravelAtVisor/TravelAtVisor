import '../utils/mappers.dart';

class Activity {
  String activityId;
  late String foursquareId;
  late DateTime timestamp;
  late String title;
  late String? description;
  late String photoUrl;

  Activity(this.activityId, this.foursquareId, this.timestamp, this.title,
      this.description, this.photoUrl);

  Activity.fromDynamic(this.activityId, dynamic data) {
    foursquareId = data["foursquareId"];
    timestamp = DynamicMappers.getDateTime(data["timestamp"]);
    title = data["title"];
    description = data["description"];
    photoUrl = data["photoUrl"];
  }

  Map<String, dynamic> toMap() {
    return {
      "foursquareId": foursquareId,
      "timestamp": timestamp.toString(),
      "title": title,
      "description": description,
      "photoUrl": photoUrl,
    };
  }
}
