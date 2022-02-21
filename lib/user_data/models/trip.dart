import 'activity.dart';

class Trip {
  String tripId;
  String title;
  DateTime begin;
  DateTime end;
  List<String> companions;
  List<Activity> activities;

  Trip(this.tripId, this.title, this.begin, this.end, this.companions,
      this.activities);
}
