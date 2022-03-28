import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/friend.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/trip_module/trip.data_service.dart';

import '../../shared_module/models/authentication_state.dart';

class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({Key? key}) : super(key: key);

  @override
  State<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  List<Friend>? availableFriends;

  @override
  Widget build(BuildContext context) {
    if (availableFriends == null) {
      final availableFriendIds =
          context.read<ApplicationState>().currentUser!.customData!.friends;
      context
          .read<TripDataService>()
          .getFriends(availableFriendIds)
          .then((value) => setState(() {
                availableFriends = value;
              }));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Freund hinzufügen"),
      ),
      body: availableFriends == null
          ? const LoadingOverlay()
          : ListView.builder(
              itemBuilder: (context, index) {
                final result = availableFriends!.elementAt(index);
                return ListTile(
                  leading: ClipOval(
                    child: Image(
                      image: NetworkImage(result.photoUrl),
                    ),
                  ),
                  title: Text(result.userId),
                  subtitle: Text(result.userId),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                );
              },
              itemCount: availableFriends!.length,
            ),
    );
  }
}
