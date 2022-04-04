extension DateExtensions on DateTime {
  /// Evaluates to true if the date of [other] is before or at the same day as the date of [this].
  bool isBeforeByDate(DateTime other) {
    return year <= other.year && month <= other.month && day <= other.day;
  }

  /// Evaluates to true if the date of [other] is after or at the same day as the date of [this].
  bool isAfterByDate(DateTime other) {
    return year >= other.year && month >= other.month && day >= other.day;
  }
}
