import 'package:flutter/material.dart';
import 'package:travel_atvisor/shared_module/views/profile_picture.dart';

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
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.header,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: IntrinsicHeight(
            child: Row(
              children: [
                widget.addPerson
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.125,
                        child: Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.15,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.addPerson
                    ? Opacity(
                        opacity: 0.2,
                        child: VerticalDivider(
                          color: Theme.of(context).colorScheme.primary,
                          width: MediaQuery.of(context).size.width * 0.06,
                          thickness: 1.5,
                          indent: 5,
                          endIndent: 5,
                        ))
                    : const SizedBox(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // for widget.person
                        const ProfilePicture(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.025,
                        ),
                        const ProfilePicture(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.025,
                        ),
                        const ProfilePicture(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.025,
                        ),
                        const ProfilePicture(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.025,
                        ),
                        const ProfilePicture(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
