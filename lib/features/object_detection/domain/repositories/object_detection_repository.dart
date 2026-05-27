import 'dart:typed_data';
import 'package:camera/camera.dart';
import '../entities/detection_result.dart';

abstract class ObjectDetectionRepository {
  Future<void> initializeModel();
  Future<List<DetectionResult>> detectObjects(CameraImage image);
  Future<List<DetectionResult>> detectObjectsFromFile(Uint8List imageBytes);
  void dispose();
}
