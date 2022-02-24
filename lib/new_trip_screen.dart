import 'package:flutter/material.dart';
import 'companions_friends.dart';
import 'shared_module/views/custom_text_input.dart';
import 'package:intl/intl.dart';

import 'design_select.dart';
import 'shared_module/views/full_width_button.dart';

class NewTripScreen extends StatefulWidget {
  const NewTripScreen({Key? key}) : super(key: key);

  @override
  _NewTripScreenState createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final _tripTitleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Neue Reise"),
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
              children: [
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
              child: CompanionsFriends(header: 'Freunde', addPerson: true),
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FullWidthButton(
                        text: "Speichern",
                        onPressed: () => {_navigateToHomeScreen(context)},
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
      initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
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

  Widget DesignCard({required bool showBorder}) {
    Color _color = Colors.blueGrey;
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
        child: Container(
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
