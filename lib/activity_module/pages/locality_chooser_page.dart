import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/activity_module/activity.data_service.dart';
import 'package:uuid/uuid.dart';

import '../models/locality_suggestion.dart';
import '../utils/debouncer.dart';
import '../views/search_mask.dart';
import 'place_search_page.dart';

class LocalityChooserPage extends StatefulWidget {
  final searchDebouncer = Debouncer(milliseconds: 200);
  final String tripId;

  LocalityChooserPage({Key? key, required this.tripId}) : super(key: key);

  @override
  _LocalityChooserPageState createState() => _LocalityChooserPageState();
}

class _LocalityChooserPageState extends State<LocalityChooserPage> {
  static const uuid = Uuid();
  String sessionToken = uuid.v4();

  @override
  Widget build(BuildContext context) {
    final placeDataService = context.read<ActivityDataService>();
    return SearchMask<LocalitySuggestion, void>(
      searchAction: (text, _) =>
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
              builder: (context) => PlaceSearchPage(
                    locality: result.name,
                    tripId: widget.tripId,
                  )));
          sessionToken = uuid.v4();
        },
      ),
      title: const Text("Stadt wählen"),
    );
  }
}
