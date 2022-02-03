import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final int maxLines;

  const CustomTextInput({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          obscureText: isPassword,
          enableSuggestions: !isPassword,
          autocorrect: !isPassword,
          maxLines: maxLines,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
          ),
        ));
  }
}
