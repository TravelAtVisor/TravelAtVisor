import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_mockup/views/trip_details_screen.dart';
import 'package:first_mockup/views/widgets/companions_friends.dart';
import 'package:flutter/material.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({Key? key}) : super(key: key);

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      TripCard('31. Januar - 14. Februar', 'New York City'),
      TripCard('31. Januar - 14. Februar', 'New York City'),
      TripCard('31. Januar - 14. Februar', 'New York City'),
      TripCard('31. Januar - 14. Februar', 'New York City'),
      TripCard('31. Januar - 14. Februar', 'New York City'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: _current == entry.key
                        ? MediaQuery.of(context).size.width * 0.0275
                        : ((_current == entry.key + 1 ||
                                _current == entry.key - 1)
                            ? MediaQuery.of(context).size.width * 0.02
                            : ((_current == entry.key + 2 ||
                                    _current == entry.key - 2)
                                ? MediaQuery.of(context).size.width * 0.0125
                                : 0.0)),
                    height: _current == entry.key
                        ? MediaQuery.of(context).size.width * 0.0275
                        : ((_current == entry.key + 1 ||
                                _current == entry.key - 1)
                            ? MediaQuery.of(context).size.width * 0.02
                            : ((_current == entry.key + 2 ||
                                    _current == entry.key - 2)
                                ? MediaQuery.of(context).size.width * 0.0125
                                : 0.0)),
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
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
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: CompanionsFriends(
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
                  return LinearGradient(
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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TripActiviesList()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget TripCard(String date, String title) {
    return GestureDetector(
      onTap: () => {_navigateToTripDetailsScreen(context)},
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
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
                padding: EdgeInsets.only(right: 0.1),
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
      ),
    );
  }
  
  Widget TripActiviesList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.46,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TripDayActivites('31. Januar'),
            TripDayActivites('31. Januar'),
            TripDayActivites('31. Januar'),
            TripDayActivites('31. Januar'),
            TripDayActivites('31. Januar')
          ],
        ),
      ),
    );
  }

  Widget TripDayActivites(String day) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
      child: Container(
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
            TripActivity('assets/empire.jpg', 'Empire State Building'),
            TripActivity('assets/empire.jpg', 'Empire State Building'),
            Opacity(
                opacity: 0.2,
                child: const Divider(
                  color: Colors.blueGrey,
                  thickness: 1.5,
                  indent: 20,
                  endIndent: 20,
                ))
          ],
        ),
      ),
    );
  }

  Widget TripActivity(String path, String name) {
    return Container(
      child: Column(
        children: [
          Row(children: [
            Image.asset(
              path,
              //height: MediaQuery.of(context).size.width * 0.25,
              width: MediaQuery.of(context).size.width * 0.25,
              fit: BoxFit.contain,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.035,
            ),
            Text(name,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ))
          ]),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          )
        ],
      ),
    );
  }

  void _navigateToTripDetailsScreen(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TripDetailsScreen()));
  }
}
