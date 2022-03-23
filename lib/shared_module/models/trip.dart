import '../utils/mappers.dart';
import 'activity.dart';

class Trip {
  String tripId;
  late String title;
  late DateTime begin;
  late DateTime end;
  late List<String> companions;
  late List<Activity> activities;

  Trip(this.tripId, this.title, this.begin, this.end, this.companions,
      this.activities);

  Trip.fromDynamic(this.tripId, dynamic data) {
    title = data["title"];
    begin = DynamicMappers.getDateTime(data["begin"]);
    end = DynamicMappers.getDateTime(data["end"]);
    var companionData = data["companions"] as List<dynamic>;
    companions = companionData.map((e) => e.toString()).toList();
    final activityData = data["activities"] as Map<dynamic, dynamic>;
    activities = activityData.entries
        .map((e) => Activity.fromDynamic(e.key, e.value))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "begin": begin.toString(),
      "end": end.toString(),
      "companions": companions,
      "activities":
          activities.toMap((item) => item.activityId, (item) => item.toMap())
    };
  }
}
