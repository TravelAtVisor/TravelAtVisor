import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final int maxLines;
  final void Function(String)? onChanged;
  final String? errorText;
  final void Function()? onEntered;
  final void Function()? onLeave;
  final TextInputAction? textInputAction;
  final bool autocorrect;
  final bool enableSuggestions;
  final List<String>? autofillHints;

  const CustomTextInput(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.isPassword = false,
      this.maxLines = 1,
      this.onChanged,
      this.errorText,
      this.onEntered,
      this.onLeave,
      this.textInputAction,
      this.autocorrect = true,
      this.enableSuggestions = true,
      this.autofillHints})
      : super(key: key);

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
          textInputAction: widget.textInputAction,
          onEditingComplete: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (widget.onLeave != null) {
              widget.onLeave!();
            }
          },
          onTap: widget.onEntered,
          obscureText: widget.isPassword,
          enableSuggestions: widget.enableSuggestions,
          autocorrect: widget.autocorrect,
          maxLines: widget.maxLines,
          controller: widget.controller,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: widget.labelText,
            errorText: isDirty ? widget.errorText : null,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
          ),
          autofillHints: widget.autofillHints,
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
