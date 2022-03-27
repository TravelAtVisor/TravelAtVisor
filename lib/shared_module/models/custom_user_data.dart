import 'package:travel_atvisor/shared_module/utils/mappers.dart';

import 'trip.dart';

class CustomUserData {
  late String nickname;
  late String fullName;
  late String? photoUrl;
  late String? biography;
  late List<Trip> trips;
  late List<String> friends;

  CustomUserData(
    this.nickname,
    this.fullName,
    this.photoUrl,
    this.biography,
    this.trips,
    this.friends,
  );

  CustomUserData.fromDynamic(dynamic data) {
    nickname = data["nickname"];
    fullName = data["fullName"];
    photoUrl = data["photoUrl"];
    biography = data["biography"];

    final tripData = data["trips"] as Map<dynamic, dynamic>;
    trips =
        tripData.entries.map((e) => Trip.fromDynamic(e.key, e.value)).toList();

    final friendsData = (data["friends"] ?? []) as List<dynamic>;
    friends = friendsData.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "nickname": nickname,
      "fullName": fullName,
      "photoUrl": photoUrl,
      "biography": biography,
      "trips": trips.toMap((item) => item.tripId, (item) => item.toMap()),
      "friends": friends,
    };
  }
}
