import 'package:cloud_firestore/cloud_firestore.dart';

class DynamicMappers {
  static DateTime fromTimestamp(dynamic data) {
    final timestamp = data as Timestamp;
    return timestamp.toDate();
  }
}

extension ListExtension<TData> on List<TData> {
  Map<TKey, TValue> toMap<TKey, TValue>(TKey Function(TData item) keyExtractor,
      TValue Function(TData item) valueExtractor) {
    return fold({}, (previousValue, element) {
      final key = keyExtractor(element);
      if (previousValue.containsKey(key)) {
        throw DuplicateKeyException(key);
      }

      final value = valueExtractor(element);

      previousValue[key] = value;

      return previousValue;
    });
  }
}

class DuplicateKeyException implements Exception {
  final dynamic duplicatedKey;

  DuplicateKeyException(this.duplicatedKey);
}
