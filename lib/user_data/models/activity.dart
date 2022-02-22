import '../../utils/mappers.dart';

class Activity {
  late String activityId;
  late String foursqareId;
  late DateTime timestamp;
  late String title;
  late String description;
  late String photoUrl;

  Activity(this.activityId, this.foursqareId, this.timestamp, this.title,
      this.description, this.photoUrl);

  Activity.fromDynamic(dynamic data) {
    activityId = data["activityId"];
    foursqareId = data["foursquareId"];
    timestamp = DynamicMappers.fromTimestamp(data["timestamp"]);
    title = data["title"];
    description = data["description"];
    photoUrl = data["photoUrl"];
  }
}
