import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:dalil/features/hieroglyphics_decoder/data/models/detected_symbol_model.dart';

class ModelLocalDataSource {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<void> loadModel() async {
    if (_isLoaded) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/models/best.tflite',
      options: InterpreterOptions()..threads = 4,
    );

    final labelData = await rootBundle.loadString('assets/models/classes.txt');
    _labels = labelData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    _isLoaded = true;
  }

  List<DetectedSymbolModel> detect(String imagePath) {
    if (!_isLoaded || _interpreter == null) {
      throw StateError('Model not loaded. Call loadModel() first.');
    }

    final imageBytes = File(imagePath).readAsBytesSync();
    final image = img.decodeImage(imageBytes);
    if (image == null) throw FormatException('Could not decode image');

    final inputShape = _interpreter!.getInputTensor(0).shape;
    final inputSize = inputShape[2];
    final isNCHW = inputShape[1] == 3;

    final input = _preprocessImage(image, inputSize, isNCHW);
    final outputTensor = _interpreter!.getOutputTensor(0);
    final outputShape = outputTensor.shape;
    final output = _createOutputBuffer(outputShape);

    _interpreter!.run(input, output);

    return _parseDetections(output, outputShape, inputSize, image.width,
        image.height, isNCHW);
  }

  dynamic _createOutputBuffer(List<int> shape) {
    if (shape.length == 3) {
      return List.generate(
        shape[0],
        (_) => List.generate(
          shape[1],
          (_) => List.filled(shape[2], 0.0),
        ),
      );
    }
    return List.generate(
      shape[0],
      (_) => List.generate(
        shape[1],
        (_) => List.filled(shape[2], 0.0),
      ),
    );
  }

  List<List<List<List<double>>>> _preprocessImage(
    img.Image image,
    int inputSize,
    bool isNCHW,
  ) {
    final resized = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
      interpolation: img.Interpolation.linear,
    );

    if (isNCHW) {
      final input = List.generate(
        1,
        (_) => List.generate(
          3,
          (_) => List.generate(
            inputSize,
            (_) => List.filled(inputSize, 0.0),
          ),
        ),
      );

      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          final pixel = resized.getPixel(x, y);
          input[0][0][y][x] = pixel.r / 255.0;
          input[0][1][y][x] = pixel.g / 255.0;
          input[0][2][y][x] = pixel.b / 255.0;
        }
      }

      return input;
    } else {
      final input = List.generate(
        1,
        (_) => List.generate(
          inputSize,
          (_) => List.generate(
            inputSize,
            (_) => List.filled(3, 0.0),
          ),
        ),
      );

      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          final pixel = resized.getPixel(x, y);
          input[0][y][x][0] = pixel.r / 255.0;
          input[0][y][x][1] = pixel.g / 255.0;
          input[0][y][x][2] = pixel.b / 255.0;
        }
      }

      return input;
    }
  }

  List<DetectedSymbolModel> _parseDetections(
    dynamic output,
    List<int> outputShape,
    int inputSize,
    int originalWidth,
    int originalHeight,
    bool isNCHW,
  ) {
    const confidenceThreshold = 0.5;
    const nmsIouThreshold = 0.4;

    final candidates = <DetectedSymbolModel>[];
    final scaleX = originalWidth / inputSize;
    final scaleY = originalHeight / inputSize;

    if (isNCHW && outputShape.length == 3) {
      final numFeatures = outputShape[1];
      final numDetections = outputShape[2];

      for (var i = 0; i < numDetections; i++) {
        final cx = output[0][0][i];
        final cy = output[0][1][i];
        final w = output[0][2][i];
        final h = output[0][3][i];

        var maxScore = 0.0;
        var classIndex = 0;
        for (var c = 4; c < numFeatures; c++) {
          final score = output[0][c][i];
          if (score > maxScore) {
            maxScore = score;
            classIndex = c - 4;
          }
        }

        if (maxScore < confidenceThreshold) continue;
        if (classIndex >= _labels.length) continue;

        candidates.add(DetectedSymbolModel.fromDetection(
          label: _labels[classIndex],
          confidence: maxScore,
          x: ((cx - w / 2) * scaleX).clamp(0.0, originalWidth.toDouble()),
          y: ((cy - h / 2) * scaleY).clamp(0.0, originalHeight.toDouble()),
          width: w * scaleX,
          height: h * scaleY,
        ));
      }
    } else {
      final numFeatures = outputShape[2];

      for (var i = 0; i < outputShape[1]; i++) {
        final cx = output[0][i][0];
        final cy = output[0][i][1];
        final w = output[0][i][2];
        final h = output[0][i][3];

        var maxScore = 0.0;
        var classIndex = 0;
        for (var c = 4; c < numFeatures; c++) {
          final score = output[0][i][c];
          if (score > maxScore) {
            maxScore = score;
            classIndex = c - 4;
          }
        }

        if (maxScore < confidenceThreshold) continue;
        if (classIndex >= _labels.length) continue;

        candidates.add(DetectedSymbolModel.fromDetection(
          label: _labels[classIndex],
          confidence: maxScore,
          x: ((cx - w / 2) * scaleX).clamp(0.0, originalWidth.toDouble()),
          y: ((cy - h / 2) * scaleY).clamp(0.0, originalHeight.toDouble()),
          width: w * scaleX,
          height: h * scaleY,
        ));
      }
    }

    candidates.sort((a, b) => b.confidence.compareTo(a.confidence));
    return _nonMaximumSuppression(candidates, nmsIouThreshold);
  }

  List<DetectedSymbolModel> _nonMaximumSuppression(
    List<DetectedSymbolModel> candidates,
    double iouThreshold,
  ) {
    final selected = <DetectedSymbolModel>[];
    final active = List<bool>.filled(candidates.length, true);

    for (var i = 0; i < candidates.length; i++) {
      if (!active[i]) continue;
      selected.add(candidates[i]);

      for (var j = i + 1; j < candidates.length; j++) {
        if (!active[j]) continue;
        if (candidates[i].label != candidates[j].label) continue;

        final iou = _calculateIoU(candidates[i], candidates[j]);
        if (iou > iouThreshold) {
          active[j] = false;
        }
      }
    }

    return selected;
  }

  double _calculateIoU(DetectedSymbolModel a, DetectedSymbolModel b) {
    final x1 = max(a.x, b.x);
    final y1 = max(a.y, b.y);
    final x2 = min(a.x + a.width, b.x + b.width);
    final y2 = min(a.y + a.height, b.y + b.height);

    final intersection = max(0, x2 - x1) * max(0, y2 - y1);
    final union = a.width * a.height + b.width * b.height - intersection;

    return union > 0 ? intersection / union : 0;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }
}
