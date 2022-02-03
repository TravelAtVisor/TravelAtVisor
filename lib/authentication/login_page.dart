import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/authentication/authentication_result.dart';

import '../divider_with_text.dart';
import '../full_width_button.dart';
import 'authentication_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signinHandler(BuildContext context) async {
    final authenticationResult =
        await context.read<AuthenticationProvider>().signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
    if (authenticationResult == AuthenticationResult.success) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Error")));
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
                  child: Column(
                    children: [
                      const Text(
                          "Bitte melde dich an, um die App zu verwenden"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "E-Mail",
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                          ),
                        ),
                      ),
                      FullWidthButton(
                        text: "Anmelden",
                        onPressed: () => signinHandler(context),
                        isElevated: true,
                      ),
                      FullWidthButton(
                          text: "Noch kein Konto? Registrieren",
                          onPressed: () {},
                          isElevated: false),
                      const DividerWithText(text: "ODER"),
                      FullWidthButton(
                        text: "Weiter mit Google",
                        onPressed: () {},
                        isElevated: false,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
