import 'trip.dart';

class CustomUserData {
  final String nickname;
  final String fullName;
  final String? photoUrl;
  final String? biography;
  final List<Trip> trips;

  CustomUserData(
      this.nickname, this.fullName, this.photoUrl, this.biography, this.trips);
}
