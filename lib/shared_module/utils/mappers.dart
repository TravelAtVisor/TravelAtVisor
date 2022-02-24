import 'package:flutter/material.dart';

import '../../trip_module/models/extended_place_data.dart';

class DynamicMappers {
  static DateTime getDateTime(dynamic data) {
    final dateString = data as String;
    return DateTime.parse(dateString);
  }

  static Day getDay(dynamic day) {
    final intDay = (day as int) - 1;
    return Day.values[intDay];
  }

  static TimeOfDay getTimeOfDay(dynamic time) {
    final timeString = time as String;
    final hours = int.parse(timeString.substring(0, 2));
    final minutes = int.parse(timeString.substring(2, 4));
    return TimeOfDay(hour: hours, minute: minutes);
  }

  static int? getInt(dynamic data) {
    if (data == null) return null;

    if (data is int) {
      return data;
    }

    if (data is double) {
      return data.toInt();
    }
  }

  static double? getDouble(dynamic data) {
    if (data == null) return null;

    if (data is int) {
      return data.toDouble();
    }

    if (data is double) {
      return data;
    }
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
