import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool isElevated;

  const FullWidthButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isElevated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      padding:
          MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12.0)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
    final description = Text(text);
    final button = isElevated
        ? ElevatedButton(
            onPressed: onPressed,
            child: description,
            style: style,
          )
        : OutlinedButton(
            onPressed: onPressed, child: description, style: style);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: button,
      ),
    );
  }
}
