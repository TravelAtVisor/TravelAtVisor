import 'package:flutter/material.dart';

import '../../activity_module/models/extended_place_data.dart';
import '../models/authentication_result.dart';

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

    return null;
  }

  static double? getDouble(dynamic data) {
    if (data == null) return null;

    if (data is int) {
      return data.toDouble();
    }

    if (data is double) {
      return data;
    }

    return null;
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

  List<TValue> mapIndexed<TValue>(
      TValue Function(TData item, int index) project) {
    final result = <TValue>[];

    for (var i = 0; i < length; i++) {
      final newValue = project(elementAt(i), i);
      result.add(newValue);
    }

    return result;
  }
}

class DuplicateKeyException implements Exception {
  final dynamic duplicatedKey;

  DuplicateKeyException(this.duplicatedKey);
}

class StringMappers {
  static AuthenticationResult getAuthenticationResult(String code) {
    switch (code) {
      case "user-not-found":
        return AuthenticationResult.unkownUser;
      case "invalid-email":
        return AuthenticationResult.invalidMail;
      case "wrong-password":
        return AuthenticationResult.wrongPassword;
      default:
        return AuthenticationResult.unexpected;
    }
  }
}
