import 'package:flutter/material.dart';
import 'package:travel_atvisor/trip_module/pages/new_trip.page.dart';
import 'package:travel_atvisor/trip_module/pages/trip_list.page.dart';
import 'package:travel_atvisor/userScreen.dart';

class GlobalTabController extends StatefulWidget {
  final router = Router({
    RouteMetadata(
      routeKey: "trip_list",
      tabDescription: "Meine Reisen",
      tabIcon: Icons.explore,
      pageBuilder: (context) => const TripList(),
    ),
    RouteMetadata(
      routeKey: "user_page",
      tabDescription: "Mein Account",
      tabIcon: Icons.person,
      pageBuilder: (context) => const UserScreen(),
    ),
  });

  GlobalTabController({Key? key}) : super(key: key);

  @override
  _GlobalTabControllerState createState() => _GlobalTabControllerState();
}

class _GlobalTabControllerState extends State<GlobalTabController> {
  late String currentRoute;

  @override
  void initState() {
    currentRoute = widget.router.initialRoute;
    super.initState();
  }

  void onNavigated(String newRoute) {
    setState(() {
      currentRoute = newRoute;
    });
  }

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: widget.router.buildPage(currentRoute, context),
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NewTrip(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: TabBar(
          routes: widget.router.knownRoutes,
          currentRoute: currentRoute,
          onNavigated: onNavigated),
    );
  }
}

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

class Router {
  final Set<RouteMetadata> _knownRoutes;

  Router(this._knownRoutes);

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

class TabBar extends StatelessWidget {
  final Iterable<RouteMetadata> routes;
  final String currentRoute;
  final void Function(String currentRoute) onNavigated;

  const TabBar(
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
            .map((e) => TabBarButton(
                metadata: e,
                currentRoute: currentRoute,
                onNavigated: onNavigated))
            .toList(),
      ),
    );
  }
}

class TabBarButton extends StatelessWidget {
  final bool showLabels;
  final RouteMetadata metadata;
  final String currentRoute;
  final void Function(String currentRoute) onNavigated;

  const TabBarButton({
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
