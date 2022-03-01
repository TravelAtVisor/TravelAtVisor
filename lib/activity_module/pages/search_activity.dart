import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/activity_module/pages/place_search_page.dart';
import 'package:uuid/uuid.dart';

import '../activity.data_service.dart';
import '../models/locality_suggestion.dart';
import '../utils/debouncer.dart';
import '../views/search_mask.dart';

class SearchActivity extends StatefulWidget {
  final searchDebouncer = Debouncer(milliseconds: 200);
  final String tripId;

  SearchActivity({Key? key, required this.tripId}) : super(key: key);

  @override
  _SearchActivityState createState() => _SearchActivityState();
}

class _SearchActivityState extends State<SearchActivity> {
  static const uuid = Uuid();
  String sessionToken = uuid.v4();

  @override
  Widget build(BuildContext context) {
    final placeDataService = context.read<ActivityDataService>();
    return SearchMask<LocalitySuggestion>(
      searchAction: (text) =>
          placeDataService.searchLocalitiesAsync(text, sessionToken),
      resultBuilder: (context, result) => ListTile(
        leading: const SizedBox(
          height: 48,
          width: 48,
          child: Center(
            child: Icon(Icons.place),
          ),
        ),
        title: Text(result.name),
        subtitle: result.descriptiveText != null
            ? Text(result.descriptiveText!)
            : null,
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PlaceSearchPage(locality: result.name, tripId: widget.tripId,)));
          sessionToken = uuid.v4();
        },
      ),
      title: const Text("Stadt wählen"),
    );
  }
}
