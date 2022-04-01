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
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

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

  String _selectedDate = '';
  String _range = '';

  @override
  Widget build(BuildContext context) {
    final dataService = context.read<TripDataService>();

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
      body: Center(
        child: Column(
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
                            fontSize:
                                MediaQuery.of(context).size.width * 0.045),
                      ),
                    )),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInput(
                        readOnly: true,
                        controller: _startDateController,
                        labelText: 'Beginn',
                        onEntered: () {
                          _calendarDialog();
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomTextInput(
                        readOnly: true,
                        controller: _endDateController,
                        labelText: 'Ende',
                        onEntered: () {
                          _calendarDialog();
                        },
                      ),
                    ),
                  ],
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
                    friendsToAdd
                        .removeWhere((element) => element.userId == uid);
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
                        onPressed: () {
                          if (_startDateController.text != "" &&
                              _endDateController.text != "" &&
                              _tripTitleController.text != "" &&
                              tripDesignPath != "") {
                            List beginL = _startDateController.text.split('.');
                            List endL = _endDateController.text.split('.');
                            createTrip(
                                    uuid.v4(),
                                    _tripTitleController.text,
                                    DateTime.parse(beginL[2] +
                                        "-" +
                                        beginL[1] +
                                        "-" +
                                        beginL[0]),
                                    DateTime.parse(endL[2] +
                                        "-" +
                                        endL[1] +
                                        "-" +
                                        endL[0]))
                                .whenComplete(
                                    () => _navigateToHomeScreen(context));
                          } else {
                            print("Not ready");
                          }
                        },
                        isElevated: false),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _calendarDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reisezeitraum wählen'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getDateRangePicker(),
                FullWidthButton(
                    text: "Okay",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    isElevated: false
                ),
              ],
            ),
          );
        });
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).pop(context);
  }

  void _setStartEndDate(DateRangePickerSelectionChangedArgs args){
    if (args.value is PickerDateRange) {
      _startDateController
        ..text = DateFormat('dd.MM.yyyy').format(args.value.startDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _startDateController.text.length,
            affinity: TextAffinity.upstream));
      _endDateController
        ..text = DateFormat('dd.MM.yyyy').format(args.value.endDate ?? args.value.startDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _endDateController.text.length,
            affinity: TextAffinity.upstream));
    } else if (args.value is DateTime) {
      _selectedDate = args.value.toString();
    }
  }

  Widget getDateRangePicker() {
    return Container(
        height: MediaQuery.of(context).size.height*0.35,
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: SfDateRangePicker(
          view: DateRangePickerView.month,
          onSelectionChanged: _setStartEndDate,
          selectionMode: DateRangePickerSelectionMode.range,
          minDate: DateTime.now(),
          cancelText: "Abbrechen",
        )
      )
    );
  }

}
