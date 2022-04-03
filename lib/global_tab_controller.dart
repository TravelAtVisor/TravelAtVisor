import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
import 'package:travel_atvisor/global.navigation_service.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/utils/page_manager.dart';
import 'package:travel_atvisor/trip_module/pages/trip_list.page.dart';
import 'package:travel_atvisor/user_module/pages/user_screen.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'shared_module/models/route_metadata.dart';
import 'shared_module/views/custom_tab_bar.dart';

import 'dart:math' as math;

class GlobalTabController extends StatefulWidget {
  final pageManager = PageManager({
    RouteMetadata(
      routeKey: "trip_list",
      tabDescription: "Meine Reisen",
      tabIcon: Icons.explore,
      pageBuilder: (context) => const TripListPage(),
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

  var isDialOpen = ValueNotifier<bool>(false);
  var extend = false;

  @override
  void initState() {
    currentRoute = widget.pageManager.initialRoute;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, state, _) => Scaffold(
        /*body: SpinCircleBottomBarHolder(
          bottomNavigationBar: SCBottomBarDetails(
            circleColors: [Colors.white, Colors.white, Colors.white],
            iconTheme: IconThemeData(color: Colors.black45),
            activeIconTheme: IconThemeData(color: Colors.orange),
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black45,fontSize: 12),
            activeTitleStyle: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),
            actionButtonDetails: SCActionButtonDetails(
              color: Colors.blueGrey,
              icon: Icon(
                Icons.expand_less,
                color: Colors.white,
              ),
              elevation: 2),
            elevation: 2,
            items: [
              SCBottomBarItem(icon: Icons.verified_user, title: "User", onPressed: () {}),
              SCBottomBarItem(icon: Icons.notifications, title: "Notifications", onPressed: () {}),
            ],
            circleItems: [
              SCItem(icon: Icon(Icons.add), onPressed: () {}),
              SCItem(icon: Icon(Icons.print), onPressed: () {})
            ],
            bnbHeight: 80
            ),
          child: PageStorage(
            child: widget.pageManager.buildPage(currentRoute, context),
            bucket: bucket,
          ),
        ),*/
        //Solution 2:
        /*body: PageStorage(
          child: widget.pageManager.buildPage(currentRoute, context),
          bucket: bucket,
        ),
        floatingActionButton: ExpandableFab(
          distance: 80.0,
          children: [
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_enhance),
            ),
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.camera),
            ),
          ],
        ),
        bottomNavigationBar: CustomTabBar(
          routes: widget.pageManager.knownRoutes,
          currentRoute: currentRoute,
          onNavigated: (newRoute) => setState(
                () {
              currentRoute = newRoute;
            },
          ),
        ),*/
        //solution 3
        body: PageStorage(
          child: widget.pageManager.buildPage(currentRoute, context),
          bucket: bucket,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          label: extend
              ? const Text("Open")
              : null,
          elevation: 8.0,
          isOpenOnStart: false,
          animationSpeed: 200,
          direction: SpeedDialDirection.up,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.accessibility),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'First',
              onTap: () => debugPrint('FIRST CHILD'),
              onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
            ),
            if (currentRoute == "trip_list") SpeedDialChild(
                child: const Icon(Icons.brush),
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                label: 'Second',
                onTap: () => debugPrint('SECOND CHILD'),
              ),
          ],
        ),
        bottomNavigationBar: CustomTabBar(
          routes: widget.pageManager.knownRoutes,
          currentRoute: currentRoute,
          onNavigated: (newRoute) => setState(
                () {
                  debugPrint('Current:' + currentRoute);
                  debugPrint('New:' + newRoute);
              currentRoute = newRoute;
            },
          ),
        ),
      ),
    );
  }
}


