  import 'package:travel_atvisor/user_data/models/activity.dart';

import 'trip.dart';

class CustomUserData {
  final String nickname;
  final String fullName;
  final String? photoUrl;
  final String? biography;
  final List<Trip> trips;

  static final dummyTrips = [
    Trip("3b64f847-9c57-48a7-9f2a-5514f857565d", "Meine geile Reise",
        DateTime.now(), DateTime.now(), [
      "972VlnX1oHWBeSLhWiTNocUhTGF3 "
    ], [
      Activity(
          "76159d12-4783-41ff-87a4-c6d5ef9d8204",
          "5412dadb498e2f6ce24e2653",
          DateTime.now(),
          "Hans im Glück",
          "Burger",
          "https://fastly.4sqi.net/img/general/original/87388367_z4tKpfgmZ2jS2cMDTsu2gQ0t5aS6qS9rOvqdcaXq9-Q.jpg")
    ])
  ];
  CustomUserData(
      this.nickname, this.fullName, this.photoUrl, this.biography, this.trips);
}
