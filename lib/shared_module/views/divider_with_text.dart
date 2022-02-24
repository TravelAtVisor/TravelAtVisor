import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            color: Colors.white,
            child: Text(
              text,
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }
}
