import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/trip_module/trip.data_service.dart';
import 'package:uuid/uuid.dart';

import '../../shared_module/models/trip.dart';
import '../../shared_module/views/companions_friends.dart';
import '../../shared_module/views/custom_text_input.dart';
import '../../shared_module/views/full_width_button.dart';
import '../views/design_select.dart';

class NewTrip extends StatefulWidget {
  const NewTrip({Key? key}) : super(key: key);

  @override
  _NewTripState createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  final _tripTitleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  Future<void> createTrip(
      String tripId, String title, DateTime begin, DateTime end) async {
    await context
        .read<TripDataService>()
        .setTripAsync(Trip(tripId, title, begin, end, [], []));
  }

  static const uuid = Uuid();

  @override
  Widget build(BuildContext context) {
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
                        controller: _startDateController,
                        labelText: 'Beginn',
                        onEntered: () {
                          _selectDate(context, _startDateController);
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomTextInput(
                        controller: _endDateController,
                        labelText: 'Ende',
                        onEntered: () {
                          _selectDate(context, _endDateController);
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
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Design',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045),
                  ),
                )),
            Row(
              children: const [
                DesignSelect(),
                //DesignCard(showBorder: false),
              ],
            ),
            /*Row(
              children: [
                DesignCard(showBorder: false),
                DesignCard(showBorder: false),
              ],
            ),*/
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.03),
              child: CompanionsFriends(
                header: 'Freunde',
                canAddPerson: true,
                addFriend: () {},
                friends: const [],
                removeFriend: (uid) {},
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
                                  DateTime.parse(
                                      endL[2] + "-" + endL[1] + "-" + endL[0]))
                              .whenComplete(
                                  () => _navigateToHomeScreen(context));
                        },
                        isElevated: false),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).pop(context);
  }

  _selectDate(
      BuildContext context, TextEditingController textController) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      textController
        ..text = DateFormat('dd.MM.yyyy').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: textController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Widget buildDesignCard({required bool showBorder}) {
    Color _color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () {
        setState(() {
          _color = Colors.red;
        });
      },
      child: Card(
        color: _color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          //side: BorderSide(width: 5, color: Colors.green),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.09,
          child: Column(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Reisetitel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
