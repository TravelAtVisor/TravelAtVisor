import 'package:flutter/material.dart';
import 'package:travel_atvisor/shared_module/views/profile_picture.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';

class CompanionsFriends extends StatefulWidget {
  final String header;

  final List<UserSuggestion> friends;
  final bool canAddPerson;
  final void Function() addFriend;
  final void Function(String userId) removeFriend;

  const CompanionsFriends({
    Key? key,
    required this.header,
    required this.canAddPerson,
    required this.friends,
    required this.addFriend,
    required this.removeFriend,
  }) : super(key: key);

  @override
  _CompanionsFriendsState createState() => _CompanionsFriendsState();
}

class _CompanionsFriendsState extends State<CompanionsFriends> {
  Widget _buildAddButton() {
    var primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        IconButton(
          color: primaryColor,
          iconSize: 32,
          icon: const Icon(Icons.add),
          onPressed: () => widget.addFriend(),
        ),
        Opacity(
          opacity: 0.2,
          child: VerticalDivider(
            color: primaryColor,
            thickness: 1.5,
            indent: 5,
            endIndent: 5,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.header,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 64,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.canAddPerson) _buildAddButton(),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...widget.friends.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          child: ProfilePicture(
                              friend: e, onRemoval: widget.removeFriend),
                        ),
                      ),
                      if (widget.friends.isEmpty)
                        const Text("Im Moment noch keine"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
