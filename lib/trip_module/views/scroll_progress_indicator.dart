import 'dart:math';

import 'package:flutter/material.dart';

class ScrollProgressIndicator extends StatelessWidget {
  static const dotSize = 10.0;
  final int elementCount;
  final int currentElement;

  const ScrollProgressIndicator(
      {Key? key, required this.elementCount, required this.currentElement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return SizedBox(
      height: 26,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          elementCount,
          (index) {
            final distanceFactor =
                pow(0.7, (index - currentElement).abs()).toDouble();
            return AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              width: dotSize * distanceFactor,
              height: dotSize * distanceFactor,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    baseColor.withOpacity(currentElement == index ? 0.9 : 0.4),
              ),
            );
          },
        ),
      ),
    );
  }
}
