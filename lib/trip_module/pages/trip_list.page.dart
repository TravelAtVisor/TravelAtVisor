import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/utils/mappers.dart';

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
    List<Widget> items = [
      buildTripCard('31. Januar - 14. Februar', 'New York City'),
      buildTripCard('31. Januar - 14. Februar', 'New York City'),
      buildTripCard('31. Januar - 14. Februar', 'New York City'),
      buildTripCard('31. Januar - 14. Februar', 'New York City'),
      buildTripCard('31. Januar - 14. Februar', 'New York City'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        toolbarHeight: MediaQuery.of(context).size.height * 0.001,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            // Card Carousel and Indicator dots
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
                          offset:
                              const Offset(0, 3), // changes position of shadow
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

            Consumer<ApplicationState>(builder: (context, state, child) {
              return ExpansionTile(
                collapsedTextColor: Colors.black,
                collapsedIconColor: Colors.black,
                title: Row(children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.035,
                  ),
                  Flexible(
                    child: Text(
                        state.currentUser!.customData!.trips[0].activities[0]
                            .title,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        )),
                  )
                ]),
                children: [
                  Text(state.currentUser!.customData!.trips[0].activities[0]
                          .description ??
                      "KEINE BESCHREIBUNG"),
                  Row(
                    children: const [],
                  )
                ],
              );
            }),

            Expanded(
              flex: 3,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment(0.0, 0.65),
                    end: Alignment(0.0, 1.0),
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                        right: MediaQuery.of(context).size.width * 0.03),
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.width * 0.03),
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
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: buildTripActiviesList()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTripCard(String date, String title) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.blueGrey,
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
                date,
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
          buildTripActivity('assets/empire.jpg', 'Empire State Building'),
          buildTripActivity('assets/empire.jpg', 'Empire State Building'),
          const Opacity(
              opacity: 0.2,
              child: Divider(
                color: Colors.blueGrey,
                thickness: 1.5,
                indent: 20,
                endIndent: 20,
              ))
        ],
      ),
    );
  }

  Widget buildTripActivity(String path, String name) {
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
      children: const [
        Text('Big Bang'),
        Text('Birth of the Sun'),
        Text('Earth is Born'),
      ],
    );
  }
}
