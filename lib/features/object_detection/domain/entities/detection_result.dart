import 'package:flutter/foundation.dart';

class DetectionResult {
  final double x;
  final double y;
  final double width;
  final double height;
  final double confidence;
  final int classId;
  final String label;

  DetectionResult({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.confidence,
    required this.classId,
    required this.label,
  });

  @override
  String toString() {
    return 'DetectionResult(label: $label, conf: $confidence, rect: [$x, $y, $width, $height])';
  }
}
