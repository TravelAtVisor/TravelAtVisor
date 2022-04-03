import 'package:flutter/material.dart';

import '../models/extended_place_data.dart';

class OpeningHourVisualizer extends StatelessWidget {
  final List<OpeningHour>? openingHours;
  final List<OpeningHour>? popularHours;
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 300, keepScrollOffset: true);

  OpeningHourVisualizer({
    Key? key,
    required this.openingHours,
    this.popularHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final open = openingHours?.map(
          (e) => _OpeningHourBarData(e.opening, e.closing, false, e.day),
        ) ??
        [];
    final popular = popularHours?.map(
          (e) => _OpeningHourBarData(e.opening, e.closing, true, e.day),
        ) ??
        [];

    final Map<Day, List<_OpeningHourBarData>> dayBarMap =
        [...open, ...popular].fold({}, (accumulator, element) {
      if (accumulator.containsKey(element.day)) {
        accumulator[element.day]!.add(element);
      } else {
        accumulator[element.day] = [element];
      }
      return accumulator;
    });
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 400,
          width: 700,
          child: CustomPaint(
            painter: OpeningHourGridPainter(
                labelStyle: Theme.of(context).textTheme.caption),
            foregroundPainter: OpeningHourBarsPainter(
              bars: dayBarMap,
              openedColor: Theme.of(context).colorScheme.primary,
              popularColor: Colors.red.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}

class _OpeningHourBarData {
  final TimeOfDay start;
  final TimeOfDay end;
  final bool isPopular;
  final Day day;

  _OpeningHourBarData(this.start, this.end, this.isPopular, this.day);
}

abstract class OpeningHourPainterBase extends CustomPainter {
  static const drawDebugPaint = false;
  static const verticalLegendPadding = 40.0;
  static const dayLabelWidth = 50.0;
  static const hoursPerDay = 24;

  final Paint _gridLegendPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.round
    ..color = Colors.grey;
  final Paint _debugGridPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0
    ..color = Colors.amber;

  final Paint _openPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 25.0
    ..strokeCap = StrokeCap.round
    ..color = Colors.blue;

  final Paint _popularPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 15.0
    ..strokeCap = StrokeCap.round
    ..color = Colors.red;

  double calculateHourSlotWidth(Size size) =>
      (size.width - dayLabelWidth) / hoursPerDay;
  double calculateHourSlotStartX(double hour, double hourSlotWidth) =>
      dayLabelWidth + hour * hourSlotWidth;
  double calculateHourSlotStartY(Size size, int dayIndex) =>
      calculateHourSlotHeight(size) * dayIndex + verticalLegendPadding;
  double calculateHourSlotHeight(Size size) =>
      (size.height - 2 * verticalLegendPadding) / Day.values.length;
}

class OpeningHourBarsPainter extends OpeningHourPainterBase {
  final Map<Day, List<_OpeningHourBarData>> bars;

  OpeningHourBarsPainter(
      {required this.bars,
      required Color openedColor,
      required Color popularColor}) {
    _openPaint.color = openedColor;
    _popularPaint.color = popularColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final slotHeight = calculateHourSlotHeight(size);
    final hourSlotWidth = calculateHourSlotWidth(size);
    for (var entry in bars.entries) {
      final hourSlotStartY = calculateHourSlotStartY(size, entry.key.index);
      final dayCenterY = hourSlotStartY + slotHeight / 2;

      for (var bar in entry.value) {
        final paint = bar.isPopular ? _popularPaint : _openPaint;

        final startX =
            calculateHourSlotStartX(getAbsoluteHours(bar.start), hourSlotWidth);
        final endX =
            calculateHourSlotStartX(getAbsoluteHours(bar.end), hourSlotWidth);

        canvas.drawLine(
            Offset(startX, dayCenterY), Offset(endX, dayCenterY), paint);
      }
    }
  }

  double getAbsoluteHours(TimeOfDay time) => time.hour + time.minute / 60;
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OpeningHourGridPainter extends OpeningHourPainterBase {
  final TextStyle? labelStyle;

  OpeningHourGridPainter({this.labelStyle});

  @override
  void paint(Canvas canvas, Size size) {
    drawDayLabels(size, OpeningHourPainterBase.verticalLegendPadding,
        OpeningHourPainterBase.dayLabelWidth, canvas);
    drawHourLabels(
        size,
        OpeningHourPainterBase.dayLabelWidth,
        OpeningHourPainterBase.hoursPerDay,
        canvas,
        OpeningHourPainterBase.verticalLegendPadding);
  }

  void drawHourLabels(Size size, double dayLabelWidth, int hoursPerDay,
      Canvas canvas, double verticalLegendPadding) {
    final hourSlotWidth = calculateHourSlotWidth(size);

    for (var i = 0; i < hoursPerDay; i += 2) {
      final lineXOffset = calculateHourSlotStartX(i.toDouble(), hourSlotWidth);

      canvas.drawLine(
          Offset(lineXOffset, verticalLegendPadding),
          Offset(lineXOffset, size.height - verticalLegendPadding),
          _gridLegendPaint);

      if (OpeningHourPainterBase.drawDebugPaint) {
        canvas.drawRect(
            Rect.fromLTWH(lineXOffset, 0, hourSlotWidth, verticalLegendPadding),
            _debugGridPaint);
      }

      final span = TextSpan(text: "$i Uhr", style: labelStyle);
      final textPainter =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      textPainter.layout();

      textPainter.paint(
          canvas,
          Offset(
              lineXOffset, (verticalLegendPadding - textPainter.height) / 2));
    }
  }

  void drawDayLabels(Size size, double verticalLegendPadding,
      double maxTextWidth, Canvas canvas) {
    final textBoxHeight = calculateHourSlotHeight(size);

    for (var element in Day.values) {
      final span = TextSpan(text: _describeDay(element), style: labelStyle);
      final textPainter =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      textPainter.layout(minWidth: 0, maxWidth: maxTextWidth);

      final xOffset = maxTextWidth - textPainter.width - 20;
      final boxStartY = calculateHourSlotStartY(size, element.index);
      final yOffset = boxStartY + textPainter.height;

      if (OpeningHourPainterBase.drawDebugPaint) {
        canvas.drawRect(
            Rect.fromLTWH(0, boxStartY, maxTextWidth, textBoxHeight),
            _debugGridPaint);
      }

      textPainter.paint(canvas, Offset(xOffset, yOffset));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  String _describeDay(Day day) {
    switch (day) {
      case Day.monday:
        return "MO";
      case Day.tuesday:
        return "DI";
      case Day.wednesday:
        return "MI";
      case Day.thursday:
        return "DO";
      case Day.friday:
        return "FR";
      case Day.saturday:
        return "SA";
      case Day.sunday:
        return "SO";
    }
  }
}
