class DynamicMappers {
  static DateTime fromString(dynamic data) {
    final dateString = data as String;
    return DateTime.parse(dateString);
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
