import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final List detections;
  final Size imageSize;
  final Size widgetSize;
  final int? selectedIndex;

  BoundingBoxPainter({
    required this.detections,
    required this.imageSize,
    required this.widgetSize,
    this.selectedIndex,
  });

  static const List<Color> _colors = [
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFFDD835),
    Color(0xFF8E24AA),
    Color(0xFFFF6D00),
    Color(0xFF00ACC1),
    Color(0xFFD81B60),
    Color(0xFF3949AB),
    Color(0xFF7CB342),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    for (var i = 0; i < detections.length; i++) {
      final detection = detections[i];
      final color = _colors[i % _colors.length];
      final isSelected = selectedIndex == i;

      final rect = Rect.fromLTWH(
        detection.x * scaleX,
        detection.y * scaleY,
        detection.width * scaleX,
        detection.height * scaleY,
      );

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 4.0 : 2.5;

      canvas.drawRect(rect, paint);

      final fillPaint = Paint()
        ..color = color.withValues(alpha: isSelected ? 0.15 : 0.08);
      canvas.drawRect(rect, fillPaint);

      final labelText = detection.label.replaceAll('_', ' ');
      final labelPainter = TextPainter(
        text: TextSpan(
          text: labelText,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSelected ? 14 : 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelHeight = labelPainter.height + 8;
      final labelWidth = labelPainter.width + 12;

      final labelRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          rect.left,
          (rect.top - labelHeight).clamp(0.0, size.height),
          labelWidth,
          labelHeight,
        ),
        const Radius.circular(4),
      );

      canvas.drawRRect(
        labelRect,
        Paint()..color = color,
      );

      labelPainter.paint(
        canvas,
        Offset(rect.left + 6, (rect.top - labelHeight).clamp(0.0, size.height) + 4),
      );
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return oldDelegate.detections != detections ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
