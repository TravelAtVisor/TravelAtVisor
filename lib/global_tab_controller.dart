import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/utils/page_manager.dart';
import 'package:travel_atvisor/trip_module/pages/trip_list.page.dart';
import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';
import 'package:travel_atvisor/userScreen.dart';

import 'activity_module/pages/locality_chooser_page.dart';
import 'shared_module/models/route_metadata.dart';
import 'shared_module/views/custom_tab_bar.dart';

class GlobalTabController extends StatefulWidget {
  final pageManager = PageManager({
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
  final PageStorageBucket bucket = PageStorageBucket();
  late String currentRoute;

  @override
  void initState() {
    currentRoute = widget.pageManager.initialRoute;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, state, _) => Scaffold(
        body: PageStorage(
          child: widget.pageManager.buildPage(currentRoute, context),
          bucket: bucket,
        ),
        floatingActionButton: state.currentTripId != null
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => context
                    .read<TripNavigationService>()
                    .pushAddActivityScreen(context, state.currentTripId!),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomTabBar(
          routes: widget.pageManager.knownRoutes,
          currentRoute: currentRoute,
          onNavigated: (newRoute) => setState(
            () {
              currentRoute = newRoute;
            },
          ),
        ),
      ),
    );
  }
}
