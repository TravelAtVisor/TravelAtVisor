import 'package:flutter/material.dart';

import '../../custom_text_input.dart';

class PasswordRequirement {
  final bool Function(String textValue) predicate;
  final String description;

  PasswordRequirement({
    required this.predicate,
    required this.description,
  });
}

class PasswordInput extends StatefulWidget {
  final void Function(bool isValid) onValidStateChanged;
  final TextEditingController controller;
  final List<PasswordRequirement> requirements;

  const PasswordInput({
    Key? key,
    required this.controller,
    required this.requirements,
    required this.onValidStateChanged,
  }) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool hasFocus = false;
  bool isValid = false;

  Iterable<Widget> buildRequirements() {
    if (!hasFocus) return [];

    return widget.requirements.map((r) => PasswordRequirementIndicator(
          description: r.description,
          isSatified: r.predicate(widget.controller.text),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextInput(
          controller: widget.controller,
          isPassword: true,
          labelText: "Passwort",
          // onChanged: onTextChanged,
          autofillHints: const [AutofillHints.password],
          onEntered: () {
            setState(() {
              hasFocus = true;
            });
          },
          onLeave: () {
            setState(() {
              hasFocus = false;
            });
          },
          textInputAction: TextInputAction.done,
          autocorrect: false,
          enableSuggestions: false,
        ),
        ...buildRequirements()
      ],
    );
  }

  void onTextChanged(text) {
    final willBeValid = widget.requirements.fold<bool>(true,
        (previousValue, element) => previousValue && element.predicate(text));
    setState(() {
      isValid = willBeValid;
    });

    if (isValid != willBeValid) widget.onValidStateChanged(willBeValid);
  }
}

class PasswordRequirementIndicator extends StatelessWidget {
  final bool isSatified;
  final String description;

  const PasswordRequirementIndicator(
      {Key? key, required this.isSatified, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Icon(
            isSatified ? Icons.check : Icons.error,
            color: isSatified ? Colors.green : Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(description),
          )
        ],
      ),
    );
  }
}
