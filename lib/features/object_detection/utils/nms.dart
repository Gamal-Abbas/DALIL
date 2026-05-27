import 'dart:math';
import '../domain/entities/detection_result.dart';

class NMS {
  static List<DetectionResult> applyNMS(List<DetectionResult> boxes, double iouThreshold) {
    if (boxes.isEmpty) return [];

    // Sort boxes by confidence in descending order
    boxes.sort((a, b) => b.confidence.compareTo(a.confidence));

    List<DetectionResult> selected = [];
    List<bool> active = List.filled(boxes.length, true);

    for (int i = 0; i < boxes.length; i++) {
      if (!active[i]) continue;
      
      selected.add(boxes[i]);
      
      for (int j = i + 1; j < boxes.length; j++) {
        if (!active[j]) continue;
        
        if (boxes[i].classId == boxes[j].classId) {
          double iou = _calculateIoU(boxes[i], boxes[j]);
          if (iou > iouThreshold) {
            active[j] = false;
          }
        }
      }
    }

    return selected;
  }

  static double _calculateIoU(DetectionResult box1, DetectionResult box2) {
    double x1 = max(box1.x - box1.width / 2, box2.x - box2.width / 2);
    double y1 = max(box1.y - box1.height / 2, box2.y - box2.height / 2);
    double x2 = min(box1.x + box1.width / 2, box2.x + box2.width / 2);
    double y2 = min(box1.y + box1.height / 2, box2.y + box2.height / 2);

    double intersectionArea = max(0.0, x2 - x1) * max(0.0, y2 - y1);
    
    double box1Area = box1.width * box1.height;
    double box2Area = box2.width * box2.height;
    
    double unionArea = box1Area + box2Area - intersectionArea;
    
    if (unionArea <= 0.0) return 0.0;
    
    return intersectionArea / unionArea;
  }
}
