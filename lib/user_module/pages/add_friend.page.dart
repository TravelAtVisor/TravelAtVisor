import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/friend.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';

import '../../shared_module/models/authentication_state.dart';
import '../../shared_module/models/trip.dart';

class AddFriendPage extends StatefulWidget {
  final Trip trip;
  const AddFriendPage({Key? key, required this.trip}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  List<Friend>? friendsAvailableToAdd;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, state, _) {
        final friendIdsAvailableToAdd = state.currentUser!.customData!.friends
            .where((f) => !widget.trip.companions.contains(f))
            .toList();

        if (friendsAvailableToAdd == null) {
          context
              .read<UserDataService>()
              .getFriends(friendIdsAvailableToAdd)
              .then(
                (value) => setState(() {
                  friendsAvailableToAdd = value;
                }),
              );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Freund hinzufügen"),
          ),
          body: friendsAvailableToAdd == null
              ? const LoadingOverlay()
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final friend = friendsAvailableToAdd!.elementAt(index);
                    return ListTile(
                      leading: ClipOval(
                        child: Image(
                          image: NetworkImage(friend.photoUrl),
                        ),
                      ),
                      title: Text(friend.userId),
                      subtitle: Text(friend.userId),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    );
                  },
                  itemCount: friendsAvailableToAdd!.length,
                ),
        );
      },
    );
  }
}
