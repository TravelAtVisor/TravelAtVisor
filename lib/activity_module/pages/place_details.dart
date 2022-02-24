import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../activity.data_service.dart';
import '../models/extended_place_data.dart';
import '../models/place_categories.dart';
import '../views/opening_hour_visualizer.dart';

class PlaceDetails extends StatefulWidget {
  final String foursquareId;

  const PlaceDetails({Key? key, required this.foursquareId}) : super(key: key);

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  ExtendedPlaceData? _details;

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
        title: const Text("Mockup.Foursquare"),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(d.name),
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
                        PlaceCategory.describe(d.categories.first)
                            .toUpperCase(),
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
              ContactRows(
                socialMediaLinks: d.socialMediaLinks,
                phoneNumber: d.phoneNumber,
                website: d.website,
              ),
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
            onTap: () => launch("tel:+49 162 7949609"),
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
                icon: const Icon(Icons.insert_chart),
                onPressed: () => launch(
                    "https://www.instagram.com/${socialMediaLinks.instagram}",
                    forceWebView: true),
              ),
            if (socialMediaLinks.twitter?.isNotEmpty ?? false)
              IconButton(
                icon: const Icon(Icons.biotech_rounded),
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
