import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/authentication/password_input.dart';
import 'package:travel_atvisor/loading_overlay.dart';

import '../custom_text_input.dart';
import '../divider_with_text.dart';
import '../full_width_button.dart';
import 'authentication_provider.dart';
import 'authentication_result.dart';

class FirstLoginStep extends StatefulWidget {
  final AnimationController animationController;

  const FirstLoginStep({
    Key? key,
    required this.animationController,
  }) : super(key: key);

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

  _FirstLoginStepState();

  Future<void> signinHandler(BuildContext context) async {
    LoadingOverlay.show(context);
    final authenticationResult =
        await context.read<AuthenticationProvider>().signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
    Navigator.pop(context);

    if (authenticationResult == AuthenticationResult.success) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Error")));
  }

  Future<void> signupHandler(BuildContext context) async {
    LoadingOverlay.show(context);
    final authenticationResult =
        await context.read<AuthenticationProvider>().signUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
    Navigator.pop(context);

    if (authenticationResult == AuthenticationResult.success) {
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
          errorText:
              _isEmailValid ? null : "Bitte geben Sie eine gültige E-Mail an",
          textInputAction: TextInputAction.next,
        ),
        PasswordInput(
          controller: passwordController,
          requirements: [
            PasswordRequirement(
                predicate: (password) => password.length >= 8,
                description: "Mindestens acht Zeichen"),
            PasswordRequirement(
                predicate: (password) => password.contains(RegExp(r"[a-z]")),
                description: "Mindestens ein Kleinbuchstabe"),
            PasswordRequirement(
                predicate: (password) => password.contains(RegExp(r"[A-Z]")),
                description: "Mindestens ein Großbuchstabe"),
            PasswordRequirement(
                predicate: (password) => password.contains(RegExp(r"[0-9]")),
                description: "Mindestens eine Ziffer"),
            PasswordRequirement(
                predicate: (password) => password.contains(RegExp(r"\W")),
                description: "Mindestens ein Sonderzeichen"),
          ],
          onValidStateChanged: (isValid) => setState(() {
            _isPasswordValid = isValid;
          }),
        ),
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
          onPressed: () {
            context.read<AuthenticationProvider>().signInWithGoogle();
          },
          isElevated: false,
        )
      ],
    );
  }
}
