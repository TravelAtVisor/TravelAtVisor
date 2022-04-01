import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
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
  const NewTrip({Key? key}) : super(key: key);

  @override
  _NewTripState createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  final _tripTitleController = TextEditingController();

  String? tripDesignPath;
  List<UserSuggestion>? friendsAvailable;
  List<UserSuggestion> friendsToAdd = [];

  Future<void> createTrip(
      String tripId, String title, DateTime begin, DateTime end) async {
    LoadingOverlay.show(context);
    await context.read<TripDataService>().setTripAsync(Trip(
        tripId,
        title,
        begin,
        end,
        friendsToAdd.map((e) => e.userId).toList(),
        [],
        tripDesignPath!));
    Navigator.pop(context);
  }

  static const uuid = Uuid();

  DateTime? startDate;
  DateTime? endDate;

  bool get _isFormValid =>
      startDate != null &&
      endDate != null &&
      _tripTitleController.text.isNotEmpty &&
      tripDesignPath != null;

  @override
  Widget build(BuildContext context) {
    final dataService = context.read<TripDataService>();
    final dateFormatter = DateFormat("d. MMMM y");

    if (friendsAvailable == null) {
      final friends =
          context.read<ApplicationState>().currentUser!.customData!.friends;
      dataService.getFriends(friends).then((value) => setState((() {
            friendsAvailable = value;
          })));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Neue Reise"),
        //toolbarHeight: MediaQuery.of(context).size.height * 0.001,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Column(
            children: [
              CustomTextInput(
                  controller: _tripTitleController,
                  labelText: 'Name der Reise'),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Reisezeitraum',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
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
                          _calendarDialog();
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
                          _calendarDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          DesignSelector(
            onPathChanged: (designPath) => setState(() {
              tripDesignPath = designPath;
            }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          if (friendsAvailable != null)
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.03),
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
            ),
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: FullWidthButton(
                    text: "Speichern",
                    onPressed: _isFormValid
                        ? () => createTrip(
                              uuid.v4(),
                              _tripTitleController.text,
                              startDate!,
                              endDate!,
                            ).whenComplete(() => _navigateToHomeScreen(context))
                        : null,
                    isElevated: false,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _calendarDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reisezeitraum wählen'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getDateRangePicker(),
                FullWidthButton(
                    text: "Okay",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    isElevated: false),
              ],
            ),
          );
        });
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).pop(context);
  }

  void _setStartEndDate(DateRangePickerSelectionChangedArgs args) {
    final range = args.value as PickerDateRange;
    setState(() {
      startDate = range.startDate;
      endDate = range.endDate;
    });
  }

  Widget getDateRangePicker() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
        child: Card(
            child: SfDateRangePicker(
          view: DateRangePickerView.month,
          onSelectionChanged: _setStartEndDate,
          selectionMode: DateRangePickerSelectionMode.range,
          minDate: DateTime.now(),
          cancelText: "Abbrechen",
        )));
  }
}
