import 'package:flutter/material.dart';

class RouteMetadata {
  final String routeKey;
  final String tabDescription;
  final IconData tabIcon;
  final Widget Function(BuildContext context) pageBuilder;

  RouteMetadata(
      {required this.routeKey,
      required this.tabDescription,
      required this.tabIcon,
      required this.pageBuilder});

  @override
  int get hashCode => routeKey.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is RouteMetadata) {
      return other.routeKey == routeKey;
    }
    return false;
  }
}
