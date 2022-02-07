import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_atvisor/authentication/authentication_dataservice.dart';
import 'package:travel_atvisor/authentication/custom_user_data.dart';

class FirebaseDataservice implements AuthenticationDataService {
  final FirebaseFirestore _firestore;

  FirebaseDataservice(this._firestore);

  @override
  Future<CustomUserData?> getCustomUserDataByIdAsync(String userId) async {
    final snapshot = await _firestore.collection("users").doc(userId).get();
    if (!snapshot.exists) return null;

    final data = snapshot.data()!;
    return CustomUserData(data["nickname"], data["fullName"], data["photoUrl"],
        data["biography"]);
  }
}
