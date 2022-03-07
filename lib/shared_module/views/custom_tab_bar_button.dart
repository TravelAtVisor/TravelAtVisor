import 'package:flutter/material.dart';

import '../models/route_metadata.dart';

class CustomTabBarButton extends StatelessWidget {
  final bool showLabels;
  final RouteMetadata metadata;
  final String currentRoute;
  final void Function(String currentRoute) onNavigated;

  const CustomTabBarButton({
    Key? key,
    required this.metadata,
    required this.currentRoute,
    required this.onNavigated,
    this.showLabels = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = metadata.routeKey == currentRoute;
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    return Expanded(
      child: MaterialButton(
        onPressed: () => onNavigated(metadata.routeKey),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.explore,
                color: color,
              ),
              if (showLabels)
                Text(metadata.tabDescription,
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
