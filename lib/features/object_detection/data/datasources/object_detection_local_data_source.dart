import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../domain/entities/detection_result.dart';
import '../../utils/image_utils.dart';
import '../../utils/nms.dart';

abstract class ObjectDetectionLocalDataSource {
  Future<void> initialize();
  Future<List<DetectionResult>> detect(CameraImage image);
  Future<List<DetectionResult>> detectFromFile(Uint8List imageBytes);
  void dispose();
}

class ObjectDetectionLocalDataSourceImpl implements ObjectDetectionLocalDataSource {
  Interpreter? _interpreter;
  Map<String, String> _classes = {};
  
  final int _inputSize = 640;
  final double _confidenceThreshold = 0.5;
  final double _iouThreshold = 0.45;

  @override
  Future<void> initialize() async {
    final labelsData = await rootBundle.loadString('assets/classes.json');
    final Map<String, dynamic> jsonMap = json.decode(labelsData);
    _classes = jsonMap.map((key, value) => MapEntry(key, value.toString()));

    final options = InterpreterOptions();
    _interpreter = await Interpreter.fromAsset('assets/model.tflite', options: options);
  }

  @override
  Future<List<DetectionResult>> detect(CameraImage image) async {
    if (_interpreter == null) throw Exception('Interpreter not initialized');

    final inputBytes = ImageUtils.cameraImageToFloat32List(image, _inputSize);
    if (inputBytes.isEmpty) return [];
    
    return _runInference(inputBytes);
  }

  @override
  Future<List<DetectionResult>> detectFromFile(Uint8List imageBytes) async {
    if (_interpreter == null) throw Exception('Interpreter not initialized');

    final inputBytes = ImageUtils.fileImageToFloat32List(imageBytes, _inputSize);
    if (inputBytes.isEmpty) return [];
    
    return _runInference(inputBytes);
  }

  List<DetectionResult> _runInference(Float32List inputBytes) {
    var input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) {
            int baseIndex = (y * _inputSize + x) * 3;
            return [
              inputBytes[baseIndex],
              inputBytes[baseIndex + 1],
              inputBytes[baseIndex + 2]
            ];
          },
        ),
      ),
    );

    final outputShape = _interpreter!.getOutputTensor(0).shape; 
    
    final output = List.generate(
      outputShape[0],
      (_) => List.generate(
        outputShape[1],
        (_) => List.filled(outputShape[2], 0.0),
      ),
    );

    _interpreter!.run(input, output);

    List<DetectionResult> results = [];
    
    int numBoxes = outputShape[1] == 5 ? outputShape[2] : outputShape[1];
    bool isTransposed = outputShape[1] == 5; 

    for (int i = 0; i < numBoxes; i++) {
      double confidence = isTransposed ? output[0][4][i] : output[0][i][4];
      if (confidence >= _confidenceThreshold) {
        double cx = isTransposed ? output[0][0][i] : output[0][i][0];
        double cy = isTransposed ? output[0][1][i] : output[0][i][1];
        double w = isTransposed ? output[0][2][i] : output[0][i][2];
        double h = isTransposed ? output[0][3][i] : output[0][i][3];

        results.add(
          DetectionResult(
            x: cx / _inputSize, 
            y: cy / _inputSize, 
            width: w / _inputSize,
            height: h / _inputSize,
            confidence: confidence,
            classId: 0,
            label: _classes['0'] ?? 'Unknown',
          )
        );
      }
    }

    return NMS.applyNMS(results, _iouThreshold);
  }

  @override
  void dispose() {
    _interpreter?.close();
  }
}
