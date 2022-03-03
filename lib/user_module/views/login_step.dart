import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/views/loading_overlay.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';

import '../../shared_module/models/authentication_result.dart';
import '../../shared_module/views/custom_text_input.dart';
import '../../shared_module/views/divider_with_text.dart';
import '../../shared_module/views/full_width_button.dart';
import '../../shared_module/views/password_input.dart';

class LoginStep extends StatefulWidget {
  final RegExp emailPattern = RegExp(
      r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

  final List<PasswordRequirement> passwordRequirements = [
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
  ];

  LoginStep({
    Key? key,
  }) : super(key: key);

  @override
  _LoginStepState createState() => _LoginStepState();
}

class _LoginStepState extends State<LoginStep> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  void _validateEmail(String email) => setState(() {
        _isEmailValid = widget.emailPattern.hasMatch(email);
      });

  _LoginStepState();

  Future<void> authenticationHandler(BuildContext context,
      Future<AuthenticationResult> Function() authCall) async {
    LoadingOverlay.show(context);
    FocusManager.instance.primaryFocus?.unfocus();
    final authenticationResult = await authCall();
    Navigator.pop(context);

    const responses = {
      AuthenticationResult.canceled: null,
      AuthenticationResult.success: null,
      AuthenticationResult.invalidMail:
          "Du hast noch kein Benutzerkonto bei uns.",
      AuthenticationResult.unkownUser:
          "Du hast noch kein Benutzerkonto bei uns.",
      AuthenticationResult.wrongPassword:
          "Das eingegebene Passwort ist falsch.",
      AuthenticationResult.unexpected: "Ein unbekannter Fehler ist aufgetreten."
    };

    final errorMessage = responses[authenticationResult];
    if (errorMessage == null) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  bool _isFormValid() => _isEmailValid && _isPasswordValid;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AutofillGroup(
          child: Column(
            children: [
              const Text("Bitte melde dich an, um die App zu verwenden"),
              CustomTextInput(
                controller: emailController,
                labelText: "E-Mail",
                onChanged: _validateEmail,
                errorText: _isEmailValid
                    ? null
                    : "Bitte geben Sie eine gültige E-Mail an",
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.email,
                  AutofillHints.username,
                  AutofillHints.newUsername
                ],
              ),
              PasswordInput(
                controller: passwordController,
                requirements: widget.passwordRequirements,
                onValidStateChanged: (isValid) => setState(() {
                  _isPasswordValid = isValid;
                }),
              ),
              FullWidthButton(
                text: "Anmelden",
                onPressed: _isFormValid()
                    ? () => authenticationHandler(
                          context,
                          () => context.read<UserDataService>().signInAsync(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                        )
                    : null,
                isElevated: true,
              ),
              FullWidthButton(
                  text: "Noch kein Konto? Registrieren",
                  onPressed: _isFormValid()
                      ? () => authenticationHandler(
                            context,
                            () => context.read<UserDataService>().signUpAsync(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                          )
                      : null,
                  isElevated: false),
              const DividerWithText(text: "ODER"),
              FullWidthButton(
                text: "Weiter mit Google",
                onPressed: () => authenticationHandler(
                    context,
                    () => context
                        .read<UserDataService>()
                        .signInWithGoogleAsync()),
                isElevated: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
