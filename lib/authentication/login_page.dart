import 'package:flutter/material.dart';
import 'package:travel_atvisor/authentication/complete_profile.dart';
import 'first_login_step.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.topCenter, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: const Image(
            image: AssetImage("assets/mountains.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 100.0,
              ),
              child: Column(children: [
                Text(
                  "Travel@visor",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ]),
            ),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
                child: CompleteProfileView(),
              ),
            ))
          ],
        ),
      ]),
    );
  }
}
