import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/authentication/models/authentication_state.dart';
import 'package:travel_atvisor/authentication/components/complete_profile_step.dart';
import 'package:travel_atvisor/keyboard_aware_builder.dart';
import 'login_step.dart';

class LoginPage extends StatefulWidget {
  final AuthenticationState authenticationState;
  const LoginPage({Key? key, required this.authenticationState})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;

  @override
  void initState() {
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    super.initState();
  }

  @override
  void didUpdateWidget(LoginPage oldWidget) {
    final authState = context.watch<AuthenticationState>();
    if (authState.currentUser != null && !authState.hasCompleteProfile) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _slideController.dispose();
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
        KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) => Column(
            children: [
              AnimatedPadding(
                duration: const Duration(milliseconds: 100),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: isKeyboardVisible ? 0 : 100,
                ),
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 40.0),
                      child: AnimatedBuilder(
                        animation: _slideController,
                        builder: (context, child) => Stack(children: [
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.5, 0),
                              end: Offset.zero,
                            ).animate(_slideController),
                            child: CompleteProfileStep(),
                          ),
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset.zero,
                              end: const Offset(-1.5, 0),
                            ).animate(_slideController),
                            child: LoginStep(
                              animationController: _slideController,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
