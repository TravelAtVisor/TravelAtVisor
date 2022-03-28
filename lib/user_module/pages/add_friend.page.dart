import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';
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
  List<UserSuggestion>? friendsAvailableToAdd;

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
                      title: Text(friend.fullName),
                      subtitle: Text(friend.userName),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        LoadingOverlay.show(context);

                        await context
                            .read<UserDataService>()
                            .addFriendToTripAsync(
                                widget.trip.tripId, friend.userId);

                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  },
                  itemCount: friendsAvailableToAdd!.length,
                ),
        );
      },
    );
  }
}
