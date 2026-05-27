import 'dart:typed_data';
import 'package:camera/camera.dart';
import '../../domain/entities/detection_result.dart';
import '../../domain/repositories/object_detection_repository.dart';
import '../datasources/object_detection_local_data_source.dart';

class ObjectDetectionRepositoryImpl implements ObjectDetectionRepository {
  final ObjectDetectionLocalDataSource localDataSource;

  ObjectDetectionRepositoryImpl({required this.localDataSource});

  @override
  Future<void> initializeModel() async {
    await localDataSource.initialize();
  }

  @override
  Future<List<DetectionResult>> detectObjects(CameraImage image) async {
    return await localDataSource.detect(image);
  }

  @override
  Future<List<DetectionResult>> detectObjectsFromFile(Uint8List imageBytes) async {
    return await localDataSource.detectFromFile(imageBytes);
  }

  @override
  void dispose() {
    localDataSource.dispose();
  }
}
