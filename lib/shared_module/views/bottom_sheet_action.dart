import 'package:flutter/material.dart';

class BottomSheetAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function() onPressed;

  const BottomSheetAction(
      {Key? key,
      required this.icon,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onPressed();
      },
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
      ),
    );
  }
}
