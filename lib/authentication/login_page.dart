import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controllers for e-mail and password textfields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Handling signup and signin
  bool signUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //e-mail textfield
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
          ),

          //password textfield
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
          ),

          //Sign in / Sign up button
          ElevatedButton(
            onPressed: () {
              if (signUp) {
                //Provider sign up method
                context.read<AuthenticationProvider>().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
              } else {
                //Provider sign in method
                context.read<AuthenticationProvider>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
              }
            },
            child: signUp ? const Text("Sign Up") : const Text("Sign In"),
          ),

          //Sign up / Sign In toggler
          OutlinedButton(
            onPressed: () {
              setState(() {
                signUp = !signUp;
              });
            },
            child: signUp
                ? const Text("Have an account? Sign In")
                : const Text("Create an account"),
          )
        ],
      ),
    );
  }
}
