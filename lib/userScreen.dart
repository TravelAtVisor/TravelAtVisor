import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/models/authentication_state.dart';
import 'package:travel_atvisor/shared_module/user_data_provider.dart';
import 'package:travel_atvisor/shared_module/views/full_width_button.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.read<AuthenticationProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Benutzer'),
      ),
      body: Consumer<AuthenticationState>(builder: (context, state, _) {
        return Center(
          child: FullWidthButton(
            isElevated: true,
            onPressed: () => userDataProvider.signOut(),
            text: state.currentUser!.email,
          ),
        );
      }),
    );
  }
}
