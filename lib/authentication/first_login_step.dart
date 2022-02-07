import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_text_input.dart';
import '../divider_with_text.dart';
import '../full_width_button.dart';
import 'authentication_provider.dart';
import 'authentication_result.dart';

class FirstLoginStep extends StatefulWidget {
  final AnimationController animationController;

  const FirstLoginStep({Key? key, required this.animationController})
      : super(key: key);

  @override
  _FirstLoginStepState createState() => _FirstLoginStepState();
}

class _FirstLoginStepState extends State<FirstLoginStep> {
  final RegExp _emailPattern = RegExp(
      r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
  final TextEditingController emailController = TextEditingController();
  bool _isEmailValid = false;
  void _validateEmail(String email) => setState(() {
        _isEmailValid = _emailPattern.hasMatch(email);
      });

  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordValid = false;
  void _validatePassword(String password) => setState(() {
        _isPasswordValid = password.length > 8 &&
            password.contains(RegExp(r"[a-z]")) &&
            password.contains(RegExp(r"[A-Z]")) &&
            password.contains(RegExp(r"[0-9]")) &&
            password.contains(RegExp(r"\W"));
        _isPasswordValid = true;
      });

  _FirstLoginStepState();

  Future<void> signinHandler(BuildContext context) async {
    final authenticationResult =
        await context.read<AuthenticationProvider>().signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

    if (authenticationResult == AuthenticationResult.success) {
      return;
    }

    if (authenticationResult == AuthenticationResult.successIncompleteProfile) {
      widget.animationController.forward();
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Error")));
  }

  Future<void> signupHandler(BuildContext context) async {
    final authenticationResult =
        await context.read<AuthenticationProvider>().signUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

    if (authenticationResult == AuthenticationResult.success) {
      return;
    }

    if (authenticationResult == AuthenticationResult.successIncompleteProfile) {
      widget.animationController.forward();
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Error")));
  }

  bool _isFormValid() => _isEmailValid && _isPasswordValid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Bitte melde dich an, um die App zu verwenden"),
        CustomTextInput(
            controller: emailController,
            labelText: "E-Mail",
            onChanged: _validateEmail,
            errorText: _isEmailValid
                ? null
                : "Bitte geben Sie eine gültige E-Mail an"),
        CustomTextInput(
            controller: passwordController,
            isPassword: true,
            labelText: "Passwort",
            onChanged: _validatePassword,
            errorText: _isPasswordValid
                ? null
                : "Ihr Passwort sollte mindestens acht Zeichen lang sein und aus mindestens einem Zeichen der folgenden Klassen bestehen: Großbuchstabe, Kleinbuchstabe, Zahl, Sonderzeichen"),
        FullWidthButton(
          text: "Anmelden",
          onPressed: _isFormValid() ? () => signinHandler(context) : null,
          isElevated: true,
        ),
        FullWidthButton(
            text: "Noch kein Konto? Registrieren",
            onPressed: _isFormValid() ? () => signupHandler(context) : null,
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
