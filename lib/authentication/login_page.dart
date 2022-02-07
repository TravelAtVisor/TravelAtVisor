import 'package:flutter/material.dart';
import 'package:travel_atvisor/authentication/authentication_state.dart';
import 'package:travel_atvisor/authentication/complete_profile.dart';
import 'first_login_step.dart';

class LoginPage extends StatefulWidget {
  final AuthenticationState authenticationState;
  const LoginPage({Key? key, required this.authenticationState})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    if (widget.authenticationState.currentUser != null &&
        !widget.authenticationState.hasCompleteProfile) {
      _animationController.forward();
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 40.0),
                child: Stack(children: [
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.5, 0),
                      end: Offset.zero,
                    ).animate(_animationController),
                    child: CompleteProfileView(),
                  ),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(-1.5, 0),
                    ).animate(_animationController),
                    child: FirstLoginStep(
                      animationController: _animationController,
                    ),
                  ),
                ]),
              ),
            ))
          ],
        ),
      ]),
    );
  }
}
