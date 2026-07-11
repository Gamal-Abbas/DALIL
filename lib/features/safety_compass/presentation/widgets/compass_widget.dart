import 'dart:math';
import 'package:flutter/material.dart';

class CompassWidget extends StatelessWidget {
  final double heading;
  final String direction;

  const CompassWidget({
    super.key,
    required this.heading,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedRotation(
                turns: -heading / 360,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: Image.asset(
                  'assets/compass/compass.png',
                  width: 220,
                  height: 220,
                  errorBuilder: (_, __, ___) => _buildFallbackCompass(theme),
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
              ),
              Positioned(
                top: 4,
                child: _buildCardinalLabel('N', theme.colorScheme.error),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${heading.toStringAsFixed(1)}°',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          direction,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackCompass(ThemeData theme) {
    return CustomPaint(
      painter: _CompassPainter(
        heading: heading,
        primaryColor: theme.colorScheme.primary,
        onSurfaceColor: theme.colorScheme.onSurface,
        outlineColor: theme.colorScheme.outlineVariant,
      ),
    );
  }

  Widget _buildCardinalLabel(String label, Color color) {
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final double heading;
  final Color primaryColor;
  final Color onSurfaceColor;
  final Color outlineColor;

  _CompassPainter({
    required this.heading,
    required this.primaryColor,
    required this.onSurfaceColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = onSurfaceColor.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    final borderPaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 1, borderPaint);

    final dirs = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90 - 90) * pi / 180;
      final tp = TextPainter(
        text: TextSpan(
          text: dirs[i],
          style: TextStyle(
            color: i == 0 ? primaryColor : onSurfaceColor,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final offset = Offset(
        center.dx + (radius - 22) * cos(angle) - tp.width / 2,
        center.dy + (radius - 22) * sin(angle) - tp.height / 2,
      );
      tp.paint(canvas, offset);
    }

    final tickPaint = Paint()
      ..color = onSurfaceColor.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;
    for (int i = 0; i < 36; i++) {
      final angle = (i * 10 - 90) * pi / 180;
      final isMajor = i % 9 == 0;
      final innerR = radius - (isMajor ? 32 : 28);
      final outerR = radius - 6;
      canvas.drawLine(
        Offset(center.dx + innerR * cos(angle), center.dy + innerR * sin(angle)),
        Offset(center.dx + outerR * cos(angle), center.dy + outerR * sin(angle)),
        tickPaint..strokeWidth = isMajor ? 2 : 1,
      );
    }

    final needlePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final needleAngle = (-heading - 90) * pi / 180;
    canvas.drawLine(
      center,
      Offset(
        center.dx + (radius - 38) * cos(needleAngle),
        center.dy + (radius - 38) * sin(needleAngle),
      ),
      needlePaint,
    );

    final tipPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(
        center.dx + (radius - 38) * cos(needleAngle),
        center.dy + (radius - 38) * sin(needleAngle),
      ),
      5,
      tipPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CompassPainter old) => old.heading != heading;
}
