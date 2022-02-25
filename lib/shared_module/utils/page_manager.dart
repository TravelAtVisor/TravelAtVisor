import 'package:flutter/material.dart';

import '../models/route_metadata.dart';

class PageManager {
  final Set<RouteMetadata> _knownRoutes;

  PageManager(this._knownRoutes);

  Widget buildPage(String routeKey, BuildContext context) {
    return _knownRoutes
        .firstWhere(
          (element) => element.routeKey == routeKey,
          orElse: () => throw InvalidRouteException(routeKey),
        )
        .pageBuilder(context);
  }

  Iterable<RouteMetadata> get knownRoutes => _knownRoutes;
  String get initialRoute => _knownRoutes.first.routeKey;
}

class InvalidRouteException implements Exception {
  String unknownRouteKey;

  InvalidRouteException(this.unknownRouteKey);
}
