import 'package:flutter/material.dart';
import '../../domain/entities/detection_result.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<DetectionResult> results;
  
  BoundingBoxPainter(this.results);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = const Color(0xFFD4AF37); // Premium Gold Accent

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (var result in results) {
      double left = (result.x - result.width / 2) * size.width;
      double top = (result.y - result.height / 2) * size.height;
      double right = (result.x + result.width / 2) * size.width;
      double bottom = (result.y + result.height / 2) * size.height;

      final rect = Rect.fromLTRB(left, top, right, bottom);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));
      
      canvas.drawRRect(rrect, paint);
      
      final labelBgPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = const Color(0xFF101010).withOpacity(0.85);

      final textSpan = TextSpan(
        text: '${result.label.toUpperCase()} ${(result.confidence * 100).toInt()}%',
        style: const TextStyle(
          color: Color(0xFFD4AF37),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      );

      textPainter.text = textSpan;
      textPainter.layout();

      final labelRect = Rect.fromLTWH(
        left + 16, 
        top - textPainter.height - 12, 
        textPainter.width + 24, 
        textPainter.height + 12
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(8)), 
        labelBgPaint
      );

      textPainter.paint(canvas, Offset(left + 28, top - textPainter.height - 6));
    }
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) {
    return oldDelegate.results != results;
  }
}
