import 'package:travel_atvisor/utils/mappers.dart';

import 'activity.dart';

class Trip {
  late String tripId;
  late String title;
  late DateTime begin;
  late DateTime end;
  late List<String> companions;
  late List<Activity> activities;

  Trip(this.tripId, this.title, this.begin, this.end, this.companions,
      this.activities);

  Trip.fromDynamic(dynamic data) {
    tripId = data["tripId"];
    title = data["title"];
    begin = DynamicMappers.fromTimestamp(data["begin"]);
    end = DynamicMappers.fromTimestamp(data["end"]);
    var companionData = data["companions"] as List<dynamic>;
    companions = companionData.map((e) => e.toString()).toList();
    final activityData = data["activities"] as List<dynamic>;
    activities = activityData.map((e) => Activity.fromDynamic(e)).toList();
  }
}
