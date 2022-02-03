import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/authentication/authentication_result.dart';

import 'authentication_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool signUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Travel@visor",
            style: Theme.of(context).textTheme.headline2,
          ),
          const Text("Bitte melde dich an, um die App zu verwenden"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final authenticationResult = await context
                                .read<AuthenticationProvider>()
                                .signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                            if (authenticationResult ==
                                AuthenticationResult.success) {
                              return;
                            }

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Error")));
                          },
                          child: const Text("Anmelden"),
                        ),
                        OutlinedButton(
                            onPressed: () {},
                            child: const Text("Noch kein Konto?"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
