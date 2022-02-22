import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/userScreen.dart';
import 'package:travel_atvisor/user_data/behaviour/user_data_provider.dart';
import 'package:travel_atvisor/user_data/models/authentication_state.dart';

import 'new_trip_screen.dart';
import 'tripScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [TripScreen(), UserScreen()];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = TripScreen();

  @override
  Widget build(BuildContext context) {
    final trips = context
        .read<AuthenticationState>()
        .currentUser!
        .customData!
        .trips
        .first;
    final dataProvider = context.read<UserDataProvider>();
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add),
        onPressed: () => {_navigateToNewTripScreen(context)},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: MediaQuery.of(context).size.height * 0.01,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          //height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.07),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                TripScreen(); // if user taps on this dashboard tab will be active
                            currentTab = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.explore,
                              color: currentTab == 0
                                  ? Colors.blueGrey
                                  : Colors.grey,
                            ),
                            Text(
                              'Reisen',
                              style: TextStyle(
                                color: currentTab == 0
                                    ? Colors.blueGrey
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.07),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                UserScreen(); // if user taps on this dashboard tab will be active
                            currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              color: currentTab == 1
                                  ? Colors.blueGrey
                                  : Colors.grey,
                            ),
                            Text(
                              'Benutzer',
                              style: TextStyle(
                                color: currentTab == 1
                                    ? Colors.blueGrey
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
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
        .push(MaterialPageRoute(builder: (context) => NewTripScreen()));
  }
}
