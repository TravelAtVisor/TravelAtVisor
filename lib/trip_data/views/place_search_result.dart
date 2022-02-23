import 'package:flutter/material.dart';

import '../models/place_core_data.dart';
import '../pages/place_details.dart';

class PlaceSearchResult extends StatelessWidget {
  final PlaceCoreData place;

  const PlaceSearchResult({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = place.photoUrls.isNotEmpty ? place.photoUrls.first : null;

    final image = imageUrl != null
        ? Image(image: NetworkImage(imageUrl))
        : const Icon(Icons.no_photography_outlined);

    return ListTile(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlaceDetails(
            foursquareId: place.foursquareId,
          ),
        ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: image,
      ),
      title: Text(place.name),
      subtitle: Row(
        children: place.categories
            .map(
              (e) => Chip(
                label: Text(
                  e.toString(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
