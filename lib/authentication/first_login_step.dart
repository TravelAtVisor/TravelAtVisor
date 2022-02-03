import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_text_input.dart';
import '../divider_with_text.dart';
import '../full_width_button.dart';
import 'authentication_provider.dart';
import 'authentication_result.dart';

class FirstLoginStep extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirstLoginStep({Key? key}) : super(key: key);

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
    return Column(
      children: [
        const Text("Bitte melde dich an, um die App zu verwenden"),
        CustomTextInput(
            controller: emailController,
            labelText: "E-Mail",
            isPassword: false),
        CustomTextInput(
          controller: passwordController,
          isPassword: true,
          labelText: "Passwort",
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
    );
  }
}
