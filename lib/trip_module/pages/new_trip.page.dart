import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/utils/date_extensions.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/trip_module/trip.data_service.dart';
import 'package:travel_atvisor/trip_module/trip.navigation_service.dart';
import 'package:travel_atvisor/trip_module/views/design_selector.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';
import 'package:uuid/uuid.dart';

import '../../shared_module/models/trip.dart';
import '../../shared_module/views/companions_friends.dart';
import '../../shared_module/views/custom_text_input.dart';
import '../../shared_module/views/full_width_button.dart';

class NewTrip extends StatefulWidget {
  final Trip? currentTrip;
  const NewTrip({
    Key? key,
    this.currentTrip,
  }) : super(key: key);

  @override
  _NewTripState createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  static const uuid = Uuid();
  late final TextEditingController _tripTitleController;

  String? tripDesignPath;
  List<UserSuggestion>? friendsAvailable;
  List<UserSuggestion> friendsToAdd = [];
  DateTime? startDate;
  DateTime? endDate;

  @override
  initState() {
    _tripTitleController =
        TextEditingController(text: widget.currentTrip?.title);
    startDate = widget.currentTrip?.begin;
    endDate = widget.currentTrip?.end;
    tripDesignPath = widget.currentTrip?.tripDesign;

    super.initState();
  }

  bool get _isNameValid => _tripTitleController.text.isNotEmpty;
  bool get _isDateRangeSet => startDate != null && endDate != null;
  bool get _isDesignValid => tripDesignPath != null;
  bool get _isFormValid =>
      _isDateRangeSet &&
      _isNameValid &&
      _isDesignValid &&
      !_hasTripAcitivitiesOutsideOfTimeRange;
  bool get _hasTripAcitivitiesOutsideOfTimeRange =>
      widget.currentTrip != null &&
      widget.currentTrip!.activities.any((element) =>
          !element.timestamp.isAfterByDate(startDate!) ||
          !element.timestamp.isBeforeByDate(endDate!));

  Widget _buildNameSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextInput(
        controller: _tripTitleController,
        labelText: 'Name der Reise',
        errorText: _isNameValid ? null : "Der Name ist ungültig",
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildDateRangeSection() {
    final dateFormatter = DateFormat("d. MMMM y");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
            child: Text("Zeitraum",
                style: Theme.of(context).textTheme.titleMedium),
          ),
          if (!_isDateRangeSet)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
              child: Text(
                "Bitte gib einen Zeitraum an.",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (_hasTripAcitivitiesOutsideOfTimeRange)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
              child: Text(
                "Einige Aktivitäten sind außerhalb des gewählten Zeitraums.",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: CustomTextInput(
                  readOnly: true,
                  controller: TextEditingController(
                      text: startDate != null
                          ? dateFormatter.format(startDate!)
                          : null),
                  labelText: 'Beginn',
                  onEntered: () {
                    _showCalendarDialog();
                  },
                ),
              ),
              Expanded(
                child: CustomTextInput(
                  readOnly: true,
                  controller: TextEditingController(
                      text: endDate != null
                          ? dateFormatter.format(endDate!)
                          : null),
                  labelText: 'Ende',
                  onEntered: () {
                    _showCalendarDialog();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CompanionsFriends(
        header: 'Freunde',
        canAddPerson: true,
        addFriend: () async {
          final newFriend = await context
              .read<TripNavigationService>()
              .pushAddFriendScreen(context, friendsAvailable!);
          if (newFriend != null) {
            setState(() {
              friendsToAdd.add(newFriend);
            });
          }
        },
        friends: friendsToAdd,
        removeFriend: (uid) => setState(() {
          friendsToAdd.removeWhere((element) => element.userId == uid);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = context.read<TripDataService>();

    if (friendsAvailable == null) {
      final friends =
          context.read<ApplicationState>().currentUser!.customData!.friends;
      dataService.getFriends(friends).then((value) => setState((() {
            friendsAvailable = value;
            friendsToAdd = widget.currentTrip?.companions
                    .map((e) =>
                        value.singleWhere((element) => element.userId == e))
                    .toList() ??
                [];
          })));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.currentTrip == null
            ? "Neue Reise"
            : "${widget.currentTrip!.title} bearbeiten"),
        actions: [
          IconButton(
            onPressed: _isFormValid
                ? () async {
                    LoadingOverlay.show(context);
                    final companions =
                        friendsToAdd.map((e) => e.userId).toList();
                    final trip = Trip(
                      widget.currentTrip?.tripId ?? uuid.v4(),
                      _tripTitleController.text,
                      startDate!,
                      endDate!,
                      companions,
                      widget.currentTrip?.activities ?? [],
                      tripDesignPath!,
                    );
                    await dataService.setTripAsync(trip);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                : null,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildNameSection(),
            _buildDateRangeSection(),
            DesignSelector(
              errorText: _isDesignValid ? null : "Bitte wähle ein Design",
              initialPath: tripDesignPath,
              onPathChanged: (designPath) => setState(() {
                tripDesignPath = designPath;
              }),
            ),
            if (friendsAvailable != null) _buildCompanionsSection(),
          ],
        ),
      ),
    );
  }

  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reisezeitraum wählen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      final range = args.value as PickerDateRange;
                      setState(() {
                        startDate = range.startDate ?? startDate;
                        endDate = range.endDate ?? endDate;
                      });
                    },
                    selectionMode: DateRangePickerSelectionMode.range,
                    minDate: DateTime.now(),
                    cancelText: "Abbrechen",
                  ),
                ),
              ),
              FullWidthButton(
                  text: "Okay",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  isElevated: false),
            ],
          ),
        );
      },
    );
  }
}
