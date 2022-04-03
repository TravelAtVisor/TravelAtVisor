import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/activity_module/views/date_time_indicator.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared_module/models/activity.dart';
import '../../shared_module/models/authentication_state.dart';
import '../activity.data_service.dart';
import '../models/extended_place_data.dart';
import '../views/opening_hour_visualizer.dart';

class PlaceDetails extends StatefulWidget {
  final String foursquareId;
  final String? tripId;

  const PlaceDetails({Key? key, required this.foursquareId, this.tripId})
      : super(key: key);

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  ExtendedPlaceData? _details;
  static const uuid = Uuid();

  DateTime? visitingDay;

  @override
  Widget build(BuildContext context) {
    loadDetails();
    return _details != null ? buildDetails(context) : buildLoader(context);
  }

  Future<void> loadDetails() async {
    if (_details != null) return;

    final details = await context
        .read<ActivityDataService>()
        .getPlaceDetailsAsync(widget.foursquareId);

    setState(() {
      _details = details;
    });
  }

  Widget buildLoader(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lade Daten..."),
      ),
      body: const Center(
        child: SizedBox(
          child: CircularProgressIndicator(),
          height: 50,
          width: 50,
        ),
      ),
    );
  }

  Widget buildDetails(BuildContext context) {
    final d = _details!;
    return Consumer<ApplicationState>(builder: (context, state, _) {
      final trip = state.currentUser!.customData!.trips
          .singleWhere((element) => element.tripId == state.currentTripId);
      return Scaffold(
        appBar: AppBar(
          title: Text(d.name),
          actions: [
            if (widget.tripId != null)
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: visitingDay != null
                    ? () async {
                        LoadingOverlay.show(context);
                        await context
                            .read<ActivityDataService>()
                            .addActivityAsync(
                              widget.tripId!,
                              Activity(
                                uuid.v4(),
                                d.foursquareId,
                                visitingDay!,
                                d.name,
                                d.description,
                                d.photoUrls.first,
                              ),
                            );
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    : null,
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CarouselSlider(
                  items: d.photoUrls
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                image: NetworkImage(e),
                              ),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                ),
                RatingsRow(generalRating: d.rating, priceRating: d.priceRating),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      if (d.categories.isNotEmpty)
                        Text(
                          d.categories.first.displayValue.toUpperCase(),
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                    ],
                  ),
                ),
                if (d.description != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(d.description!),
                  ),
                ListTile(
                  leading: const Icon(Icons.map),
                  title: Text(
                    "Adresse",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(d.address?.formatted ?? "In Karten öffnen"),
                  onTap: () => d.address != null
                      ? MapsLauncher.launchQuery(d.address!.formatted)
                      : MapsLauncher.launchCoordinates(
                          d.geocodes.latitude, d.geocodes.longitude),
                ),
                ContactRows(
                  socialMediaLinks: d.socialMediaLinks,
                  phoneNumber: d.phoneNumber,
                  website: d.website,
                ),
                if (widget.tripId != null)
                  DateTimeIndicator(
                      date: visitingDay,
                      onPressed: () async {
                        final dateBase = await showDatePicker(
                          context: context,
                          initialDate: trip.begin,
                          firstDate: trip.begin,
                          lastDate: trip.end,
                        );

                        if (dateBase == null) return;

                        final time = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(
                            hour: 12,
                            minute: 0,
                          ),
                        );

                        if (time == null) return;
                        final date = dateBase.add(
                            Duration(hours: time.hour, minutes: time.minute));

                        setState(() {
                          visitingDay = date;
                        });
                      }),
                if (d.openingHours != null || d.popularHours != null)
                  OpeningHourVisualizer(
                    openingHours: d.openingHours,
                    popularHours: d.popularHours,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ContactRows extends StatelessWidget {
  final String? phoneNumber;
  final String? website;
  final SocialMediaLinks socialMediaLinks;

  const ContactRows(
      {Key? key,
      this.phoneNumber,
      this.website,
      required this.socialMediaLinks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (phoneNumber != null)
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(phoneNumber!),
            onTap: () => launch("tel:$phoneNumber"),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (website != null)
              IconButton(
                icon: const Icon(Icons.link),
                onPressed: () => launch(website!),
              ),
            if (socialMediaLinks.facebookId?.isNotEmpty ?? false)
              IconButton(
                icon: const Icon(Icons.facebook),
                onPressed: () => launch(
                    "https://www.facebook.com/profile.php?id=${socialMediaLinks.facebookId}",
                    forceWebView: true),
              ),
            if (socialMediaLinks.instagram?.isNotEmpty ?? false)
              IconButton(
                icon: const Icon(FontAwesomeIcons.instagram),
                onPressed: () => launch(
                    "https://www.instagram.com/${socialMediaLinks.instagram}",
                    forceWebView: true),
              ),
            if (socialMediaLinks.twitter?.isNotEmpty ?? false)
              IconButton(
                icon: const Icon(FontAwesomeIcons.twitter),
                onPressed: () => launch(
                    "https://twitter.com/${socialMediaLinks.twitter}",
                    forceWebView: true),
              )
          ],
        )
      ],
    );
  }
}

class RatingsRow extends StatelessWidget {
  final double? generalRating;
  final int? priceRating;

  const RatingsRow(
      {Key? key, required this.generalRating, required this.priceRating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final generalStars = generalRating != null
        ? List.generate(
            5,
            (index) => Icon(
              Icons.star,
              color: (generalRating! / 2) < index ? Colors.grey : Colors.amber,
            ),
          )
        : [];
    final priceIndicator = priceRating != null
        ? List.generate(
            4,
            (index) => Icon(
              Icons.euro,
              color: priceRating! < index
                  ? Colors.black.withOpacity(0.5)
                  : Colors.black,
            ),
          )
        : [];

    final separator = generalStars.isNotEmpty && priceIndicator.isNotEmpty
        ? const [Spacer()]
        : [];
    return Row(
      children: [
        const Spacer(),
        ...generalStars,
        ...separator,
        ...priceIndicator,
        const Spacer()
      ],
    );
  }
}
