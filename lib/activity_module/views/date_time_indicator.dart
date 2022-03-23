import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeIndicator extends StatelessWidget {
  final DateTime date;
  final String? label;
  final String formatLiteral;
  final void Function() onPressed;

  const DateTimeIndicator({
    Key? key,
    this.label,
    this.formatLiteral = "dd. MMMM y HH:m",
    required this.date,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(formatLiteral);
    var foregroundColor = Colors.black.withOpacity(0.8);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) Text(label!),
          ClipRRect(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.black.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      dateFormat.format(date),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: foregroundColor),
                    ),
                  ),
                  IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.edit),
                    splashRadius: 24.0,
                    color: foregroundColor,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
