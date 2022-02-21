import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_data/behaviour/user_data_provider.dart';
import 'user_data/models/authentication_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AuthenticationState>(
          builder: (context, state, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("WELCOME HOME", style: TextStyle(fontSize: 30)),
              ElevatedButton(
                onPressed: () {
                  context.read<UserDataProvider>().signOut();
                },
                child: Text("Sign out ${state.currentUser?.email}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
