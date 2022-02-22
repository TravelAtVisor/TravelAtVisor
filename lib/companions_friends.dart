import 'package:flutter/material.dart';
import 'package:travel_atvisor/profile_picture.dart';

class CompanionsFriends extends StatefulWidget {
  final String header;

  // final List<String> person;
  final bool addPerson;

  const CompanionsFriends(
      {Key? key, required this.header, required this.addPerson})
      : super(key: key);

  @override
  _CompanionsFriendsState createState() => _CompanionsFriendsState();
}

class _CompanionsFriendsState extends State<CompanionsFriends> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Expanded(
        flex: 3,
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.header,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045),
            ),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        widget.addPerson
                            ? Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.125,
                                child: Center(
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        color: Colors.blueGrey),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        widget.addPerson
                            ? Opacity(
                                opacity: 0.2,
                                child: VerticalDivider(
                                  color: Colors.blueGrey,
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                  thickness: 1.5,
                                  indent: 5,
                                  endIndent: 5,
                                ))
                            : SizedBox(),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // for widget.person
                                ProfilePicture(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                ProfilePicture(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                ProfilePicture(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                ProfilePicture(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                ProfilePicture(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}