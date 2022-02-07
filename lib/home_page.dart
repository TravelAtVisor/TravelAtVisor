import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/authentication/authentication_state.dart';

import 'authentication/authentication_provider.dart';

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
                  context.read<AuthenticationProvider>().signOut();
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
