import '../utils/mappers.dart';
import 'activity.dart';

class Trip {
  String tripId;
  String title;
  DateTime begin;
  DateTime end;
  List<String> companions;
  List<Activity> activities;
  String tripDesign;

  Trip(this.tripId, this.title, this.begin, this.end, this.companions,
      this.activities, this.tripDesign);

  static Trip fromDynamic(String tripId, dynamic data) {
    final companionData = data["companions"] as List<dynamic>;
    final activityData = data["activities"] as Map<dynamic, dynamic>;
    return Trip(
      tripId,
      data["title"],
      DynamicMappers.getDateTime(data["begin"]),
      DynamicMappers.getDateTime(data["end"]),
      companionData.map((e) => e.toString()).toList(),
      activityData.entries
          .map((e) => Activity.fromDynamic(e.key, e.value))
          .toList(),
      data["design"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "begin": begin.toString(),
      "end": end.toString(),
      "companions": companions,
      "activities":
          activities.toMap((item) => item.activityId, (item) => item.toMap()),
      "design": tripDesign,
    };
  }
}
