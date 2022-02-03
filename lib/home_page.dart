import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication/authentication_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<User?>(
          builder: (context, value, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("WELCOME HOME", style: TextStyle(fontSize: 30)),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationProvider>().signOut();
                },
                child: Text("Sign out ${value?.email}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
