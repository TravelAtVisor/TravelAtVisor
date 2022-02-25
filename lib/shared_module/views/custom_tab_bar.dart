import 'package:flutter/material.dart';

import '../models/route_metadata.dart';
import 'custom_tab_bar_button.dart';

class CustomTabBar extends StatelessWidget {
  final Iterable<RouteMetadata> routes;
  final String currentRoute;
  final void Function(String currentRoute) onNavigated;

  const CustomTabBar(
      {Key? key,
      required this.routes,
      required this.currentRoute,
      required this.onNavigated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: routes
            .map((e) => CustomTabBarButton(
                metadata: e,
                currentRoute: currentRoute,
                onNavigated: onNavigated))
            .toList(),
      ),
    );
  }
}
