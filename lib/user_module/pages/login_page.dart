import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/views/keyboard_aware_builder.dart';

import '../../shared_module/models/authentication_state.dart';
import '../views/complete_profile_step.dart';
import '../views/login_step.dart';

class LoginPage extends StatefulWidget {
  final ApplicationState authenticationState;
  static const animationDuration = Duration(milliseconds: 150);
  const LoginPage({Key? key, required this.authenticationState})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(alignment: Alignment.topCenter, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: const Image(
            image: AssetImage("assets/mountains.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) => Column(
              children: [
                AnimatedPadding(
                  duration: LoginPage.animationDuration,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: isKeyboardVisible ? 0 : 100,
                  ),
                ),
                Expanded(
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: isKeyboardVisible
                          ? null
                          : const BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                      color: Colors.white,
                    ),
                    duration: LoginPage.animationDuration,
                    child: Consumer<ApplicationState>(
                      builder: (context, value, child) => SafeArea(
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: LoginPage.animationDuration,
                              width: deviceWidth,
                              curve: Curves.easeInOut,
                              left: value.isLoggedIn ? 0 : deviceWidth,
                              top: 0,
                              bottom: 0,
                              child: const CompleteProfileStep(),
                            ),
                            AnimatedPositioned(
                              duration: LoginPage.animationDuration,
                              width: deviceWidth,
                              curve: Curves.easeInOut,
                              left: value.isLoggedIn ? -deviceWidth : 0,
                              top: 0,
                              bottom: 0,
                              child: LoginStep(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
