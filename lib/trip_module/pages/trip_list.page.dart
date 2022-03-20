import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:intl/intl.dart';
import 'package:travel_atvisor/trip_module/trip.data_service.dart';
import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';

import '../../shared_module/models/activity.dart';
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
    final List<Trip> trips = context
        .watch<ApplicationState>()
        .currentUser!
        .customData!
        .trips;
    trips.sort((b, c) => b.begin.compareTo(c.begin));


    context.read<TripDataService>().setActiveTripId(trips.elementAt(_current).tripId);

    List<Widget> items = [];
    for(var item = 0; item < trips.length; item++){
      items.add(buildTripCard(trips[item].begin, trips[item].end, trips[item].title));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: MediaQuery.of(context).size.height * 0.001,
      ),
      body: Center(
        child:
        Consumer<ApplicationState>(builder: (context, state, child) {
          return state.currentUser!.customData!.trips.isNotEmpty
            ? Column(
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
                  Container(
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

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  ShaderMask(
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
                          child: buildTripActiviesList(trips[_current])
                      ),
                    ),
                ],
            ) 
            : Column(
                children: [
                  Text("Willkommen beim Travek@Visor. Es ist Zeit zu verreisen. Los, lege mit dem \"+\" Button deine erste Reise an!")
                ],
            );
        }),
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

  Widget buildTripActiviesList(Trip trip) {
    final groupedByDay = trip.activities.fold(
        <DateTime,List<Activity>>{}, (Map<DateTime, List<Activity>> previousValue, element) {
          if (previousValue.containsKey(element.timestamp)) {
            previousValue[element.timestamp]!.add(element);
          } else {
            previousValue[element.timestamp] = [element];
          }
       return previousValue;
    });
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.46,
      child: ListView.builder(
          itemBuilder: (context, index) => buildTripDayActivites(groupedByDay.values.elementAt(index), trip.tripId),
          itemCount: groupedByDay.length,
      ),

    );
  }

  Widget buildTripDayActivites(List<Activity> activities, String tripId) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(DateFormat('dd.MM.yyyy').format(activities.first.timestamp),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          ...activities.map((e) => buildTripActivity(e, tripId)),
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

  Widget buildTripActivity(Activity activity, String tripId) {
    return ExpansionTile(
      collapsedTextColor: Colors.black,
      collapsedIconColor: Colors.black,
      title: Row(children: [
        Image.network(
          activity.photoUrl,
          height: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.25,
          fit: BoxFit.contain,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.035,
        ),
        Flexible(
          child: Text(activity.title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              )),
        )
      ]),
      children: [
        Text(activity.description??"Keine Beschreibung verfügbar."),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: () => context.read<TripNavigationService>().pushActivityDetailScreen(context, activity.foursquareId), icon: Icon(Icons.info), color: Colors.grey, iconSize: MediaQuery.of(context).size.width * 0.07,),
            IconButton(onPressed: () => context.read<TripDataService>().deleteActivityAsync(tripId, activity.activityId), icon: Icon(Icons.delete), color: Colors.grey, iconSize: MediaQuery.of(context).size.width * 0.07,),
          ],
        )
      ],
    );
  }
}
