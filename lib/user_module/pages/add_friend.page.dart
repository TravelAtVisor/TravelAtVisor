import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';

import '../../shared_module/models/authentication_state.dart';

class AddFriendPage extends StatefulWidget {
  final List<UserSuggestion> friendsToAdd;
  const AddFriendPage({Key? key, required this.friendsToAdd}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Freund hinzufügen"),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) {
              final friend = widget.friendsToAdd.elementAt(index);
              return ListTile(
                leading: ClipOval(
                  child: Image(
                    image: NetworkImage(friend.photoUrl),
                  ),
                ),
                title: Text(friend.fullName),
                subtitle: Text(friend.userName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pop(context, friend),
              );
            },
            itemCount: widget.friendsToAdd.length,
          ),
        );
      },
    );
  }
}
