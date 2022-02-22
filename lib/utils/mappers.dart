import 'package:cloud_firestore/cloud_firestore.dart';

class DynamicMappers {
  static DateTime fromTimestamp(dynamic data) {
    final timestamp = data as Timestamp;
    return timestamp.toDate();
  }
}
