import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/views/full_width_button.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.read<UserDataService>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Benutzer'),
      ),
      body: Consumer<ApplicationState>(builder: (context, state, _) {
        return Center(
          child: FullWidthButton(
            isElevated: true,
            onPressed: () => userDataProvider.signOutAsync(),
            text: state.currentUser!.email,
          ),
        );
      }),
    );
  }
}
