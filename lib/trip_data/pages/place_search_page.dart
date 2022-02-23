import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/trip_data/trip_dataservice.dart';

import '../models/place_core_data.dart';
import '../utils/debouncer.dart';
import '../views/search_mask.dart';
import 'place_details.dart';

class PlaceSearchPage extends StatefulWidget {
  final searchDebouncer = Debouncer(milliseconds: 200);
  final String locality;

  PlaceSearchPage({Key? key, required this.locality}) : super(key: key);

  @override
  _PlaceSearchPageState createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  @override
  Widget build(BuildContext context) {
    final placeDataService = context.read<TripDataservice>();

    return SearchMask<PlaceCoreData>(
      title: Text("Plätze in ${widget.locality}"),
      searchAction: (text) =>
          placeDataService.searchPlacesAsync(text, widget.locality),
      resultBuilder: (context, result) => ListTile(
        leading: result.photoUrls.isNotEmpty
            ? Image(image: NetworkImage(result.photoUrls.first))
            : const Icon(Icons.camera),
        title: Text(result.name),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: result.categories
                .map((e) => Chip(label: Text(e.toString())))
                .toList(),
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PlaceDetails(foursquareId: result.foursquareId))),
      ),
    );
  }
}
