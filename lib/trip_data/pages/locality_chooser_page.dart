import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/trip_data/trip_dataservice.dart';
import 'package:uuid/uuid.dart';

import '../models/locality_suggestion.dart';
import '../utils/debouncer.dart';
import '../views/search_mask.dart';
import 'place_search_page.dart';

class LocalityChooserPage extends StatefulWidget {
  final searchDebouncer = Debouncer(milliseconds: 200);
  LocalityChooserPage({Key? key}) : super(key: key);

  @override
  _LocalityChooserPageState createState() => _LocalityChooserPageState();
}

class _LocalityChooserPageState extends State<LocalityChooserPage> {
  static const uuid = Uuid();
  String sessionToken = uuid.v4();

  @override
  Widget build(BuildContext context) {
    final placeDataService = context.read<TripDataservice>();
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
              builder: (context) => PlaceSearchPage(locality: result.name)));
          sessionToken = uuid.v4();
        },
      ),
      title: const Text("Stadt wählen"),
    );
  }
}
