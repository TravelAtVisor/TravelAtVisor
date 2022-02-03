import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final Widget child;

  const CustomElevatedButton(
      {Key? key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.blue,
      splashColor: Colors.blue[400],
      child: Padding(padding: const EdgeInsets.all(13.0), child: child),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final Widget child;

  const CustomOutlinedButton(
      {Key? key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      splashColor: Colors.blue[400],
      child: Padding(padding: const EdgeInsets.all(13.0), child: child),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
