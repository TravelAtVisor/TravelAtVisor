import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/activity_module/pages/search_activity.dart';
import 'package:travel_atvisor/trip_module/pages/new_trip.page.dart';
import 'package:travel_atvisor/trip_module/pages/trip_list.page.dart';
import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';
import 'package:travel_atvisor/userScreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [const TripList(), const UserScreen()];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const TripList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
        onPressed: () => context.read<TripNavigationService>().pushAddActivityScreen(context, '09a37987-fd56-4416-8b39-e6895a75166e'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: MediaQuery.of(context).size.height * 0.01,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
          //height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.07),
                  child: MaterialButton(
                    onPressed: () => setState(() {
                      currentScreen =
                          const TripList(); // if user taps on this dashboard tab will be active
                      currentTab = 0;
                    }),
                    child: Icon(
                      Icons.explore,
                      color: currentTab == 0 ? Colors.blueGrey : Colors.grey,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.07),
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            const UserScreen(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Icon(
                      Icons.person,
                      color: currentTab == 1 ? Colors.blueGrey : Colors.grey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToNewTripScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewTrip()));
  }
}
