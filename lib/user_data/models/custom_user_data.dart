import 'package:travel_atvisor/utils/mappers.dart';

import 'trip.dart';

class CustomUserData {
  late String nickname;
  late String fullName;
  late String? photoUrl;
  late String? biography;
  late List<Trip> trips;

  CustomUserData(
      this.nickname, this.fullName, this.photoUrl, this.biography, this.trips);

  CustomUserData.fromDynamic(dynamic data) {
    nickname = data["nickname"];
    fullName = data["fullName"];
    photoUrl = data["photoUrl"];
    biography = data["biography"];

    final tripData = data["trips"] as Map<String, dynamic>;
    trips =
        tripData.entries.map((e) => Trip.fromDynamic(e.key, e.value)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "nickname": nickname,
      "fullName": fullName,
      "photoUrl": photoUrl,
      "biography": biography,
      "trips": trips.toMap((item) => item.tripId, (item) => item.toMap()),
    };
  }
}
