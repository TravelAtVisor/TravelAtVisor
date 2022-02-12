import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final int maxLines;
  final void Function(String)? onChanged;
  final String? errorText;

  const CustomTextInput({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.maxLines = 1,
    this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  bool isDirty = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          obscureText: widget.isPassword,
          enableSuggestions: !widget.isPassword,
          autocorrect: !widget.isPassword,
          maxLines: widget.maxLines,
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: isDirty ? widget.errorText : null,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
          ),
          onChanged: (e) {
            setState(() {
              isDirty = true;
              if (widget.onChanged != null) {
                widget.onChanged!(e);
              }
            });
          },
        ));
  }
}
