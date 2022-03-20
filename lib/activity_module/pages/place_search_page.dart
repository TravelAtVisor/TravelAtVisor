import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/activity_module/activity.data_service.dart';
import 'package:travel_atvisor/activity_module/models/place_categories.dart';

import '../models/place_core_data.dart';
import '../utils/debouncer.dart';
import '../views/search_mask.dart';
import 'place_details.dart';

class PlaceSearchPage extends StatefulWidget {
  final searchDebouncer = Debouncer(milliseconds: 200);
  final String locality;
  final String tripId;

  PlaceSearchPage({Key? key, required this.locality, required this.tripId}) : super(key: key);

  @override
  _PlaceSearchPageState createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  @override
  Widget build(BuildContext context) {
    final placeDataService = context.read<ActivityDataService>();

    return SearchMask<PlaceCoreData, PlaceCategory>(
      title: Text("Plätze in ${widget.locality}"),
      searchAction: (text, suggestionFilter) => placeDataService
          .searchPlacesAsync(text, widget.locality, suggestionFilter),
      suggestionFilterBuilder:
          (context, activeSuggestionFilter, setSuggestionFilter) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: PlaceCategory.categories.values.map(
              (e) {
                final color = activeSuggestionFilter == e
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black38;
                return GestureDetector(
                  onTap: () => setSuggestionFilter(
                      e == activeSuggestionFilter ? null : e),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          e.iconData,
                          size: 48,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
      resultBuilder: (context, result) => ListTile(
        leading: result.photoUrls.isNotEmpty
            ? Image(image: NetworkImage(result.photoUrls.first))
            : const Icon(Icons.camera),
        title: Text(result.name),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: result.categories
                .map((e) => Chip(label: Text(e.displayValue)))
                .toList(),
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PlaceDetails(foursquareId: result.foursquareId, tripId: widget.tripId,))),
      ),
    );
  }
}
