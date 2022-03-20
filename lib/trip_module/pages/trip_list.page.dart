import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:intl/intl.dart';
import 'package:travel_atvisor/trip_module/trip.data_service.dart';
import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';

import '../../shared_module/models/trip.dart';
import '../../shared_module/views/companions_friends.dart';
import '../views/scroll_progress_indicator.dart';

class TripList extends StatefulWidget {
  const TripList({Key? key}) : super(key: key);

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final List<Trip> trips =
        context.watch<ApplicationState>().currentUser!.customData!.trips;
    trips.sort((b, c) => b.begin.compareTo(c.begin));

    if (trips.isNotEmpty) {
      context
          .read<TripDataservice>()
          .setActiveTripId(trips.elementAt(_current).tripId);
    }

    List<Widget> items = [];
    for (var item = 0; item < trips.length; item++) {
      items.add(
          buildTripCard(trips[item].begin, trips[item].end, trips[item].title));
    }

    return Consumer<ApplicationState>(
      builder: (context, state, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: state.currentUser!.customData!.trips.isNotEmpty
              ? [
                  IconButton(
                    onPressed: () => context
                        .read<TripNavigationService>()
                        .pushAddActivityScreen(
                            context, trips.elementAt(_current).tripId),
                    icon: const Icon(Icons.plus_one),
                  ),
                ]
              : [],
        ),
        body: Center(
            child: state.currentUser!.customData!.trips.isNotEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      CarouselSlider(
                        items: items,
                        carouselController: _controller,
                        options: CarouselOptions(
                            enableInfiniteScroll: false,
                            height: MediaQuery.of(context).size.height * 0.19,
                            viewportFraction: 0.93,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                      ScrollProgressIndicator(
                        elementCount: items.length,
                        currentElement: _current,
                      ),
                      IntrinsicHeight(
                        child: Expanded(
                          flex: 1,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.03,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.25),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: const CompanionsFriends(
                                  header: 'Begleiter', addPerson: true)),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Expanded(
                        flex: 3,
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment(0.0, 0.65),
                              end: Alignment(0.0, 1.0),
                              colors: [Colors.black, Colors.transparent],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.dstIn,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.03),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.25),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: buildTripActiviesList()),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: const [
                      Text(
                          "Willkommen beim Travel@Visor. Es ist Zeit zu verreisen. Los, lege mit dem \"+\" Button deine erste Reise an!")
                    ],
                  )),
      ),
    );
  }

  Widget buildTripCard(DateTime begin, DateTime end, String title) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.19,
        child: Column(
          children: [
            ListTile(
              title: Text(
                formatter.format(begin) + " - " + formatter.format(end),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.035),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0.1),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTripActiviesList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.46,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            buildTripDayActivites('31. Januar'),
            buildTripDayActivites('31. Januar'),
            buildTripDayActivites('31. Januar'),
            buildTripDayActivites('31. Januar'),
            buildTripDayActivites('31. Januar')
          ],
        ),
      ),
    );
  }

  Widget buildTripDayActivites(String day) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(day,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          buildTripActivity('assets/empire.jpg', 'Empire State Building',
              'The Empire State Building is an iconic staple of New York City history. From King Kong to Tom Hanks, it has been a focal point of the New York skyline.'),
          buildTripActivity('assets/empire.jpg', 'Empire State Building',
              'The Empire State Building is an iconic staple of New York City history. From King Kong to Tom Hanks, it has been a focal point of the New York skyline.'),
          Opacity(
              opacity: 0.2,
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1.5,
                indent: 20,
                endIndent: 20,
              ))
        ],
      ),
    );
  }

  Widget buildTripActivity(String path, String name, String description) {
    return ExpansionTile(
      collapsedTextColor: Colors.black,
      collapsedIconColor: Colors.black,
      title: Row(children: [
        Image.asset(
          path,
          height: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.25,
          fit: BoxFit.contain,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.035,
        ),
        Flexible(
          child: Text(name,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              )),
        )
      ]),
      children: [
        Text(description),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => print("infos"),
              icon: Icon(Icons.info),
              color: Colors.grey,
              iconSize: MediaQuery.of(context).size.width * 0.07,
            ),
            IconButton(
              onPressed: () => print("bearbeiten"),
              icon: Icon(Icons.settings),
              color: Colors.grey,
              iconSize: MediaQuery.of(context).size.width * 0.07,
            ),
            IconButton(
              onPressed: () => print("löschen"),
              icon: Icon(Icons.delete),
              color: Colors.grey,
              iconSize: MediaQuery.of(context).size.width * 0.07,
            ),
          ],
        )
      ],
    );
  }
}
