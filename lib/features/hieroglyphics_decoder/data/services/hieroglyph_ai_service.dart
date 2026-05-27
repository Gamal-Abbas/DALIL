import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class HieroglyphResult {
  final String arabicName;
  final String phonetic;
  final String description;
  final double confidence;

  HieroglyphResult({
    required this.arabicName,
    required this.phonetic,
    required this.description,
    required this.confidence,
  });
}

class HieroglyphAiService {
  Interpreter? _interpreter;
  List<String> _classes = [];
  Map<String, dynamic> _translations = {};
  bool _isInitialized = false;

  Future<void> init() async {
    try {
      // 1. Load the model
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');

      // 2. Load classes.json
      final classesJsonString = await rootBundle.loadString('assets/classes.json');
      final dynamic decodedJson = json.decode(classesJsonString);
      if (decodedJson is List) {
        _classes = decodedJson.map((e) => e.toString()).toList();
      } else if (decodedJson is Map) {
        _classes = decodedJson.values.map((e) => e.toString()).toList();
      }

      // 3. Load translations.json removed
      _translations = {};

      _isInitialized = true;
    } catch (e) {
      print("Error initializing HieroglyphAiService: $e");
      _isInitialized = false;
    }
  }

  Future<HieroglyphResult?> predict(String imagePath) async {
    if (!_isInitialized || _interpreter == null) {
      print("Service is not initialized.");
      return null;
    }

    try {
      // 1. Process Image
      final input = await _processImage(imagePath);
      if (input == null) return null;

      // 2. Run Inference
      // Output shape is [1, 95] based on instructions
      var output = List.filled(1 * 95, 0.0).reshape([1, 95]);
      
      _interpreter!.run(input, output);

      // 3. Find highest probability
      List<double> probabilities = (output[0] as List).cast<double>();
      print("Raw output probabilities: \$probabilities");

      double maxProb = probabilities.reduce(math.max);
      int maxIndex = probabilities.indexOf(maxProb);

      // 4. Translation Mapping
      if (maxIndex < _classes.length) {
        String className = _classes[maxIndex];
        
        // Fetch from translations
        if (_translations.containsKey(className)) {
          final data = _translations[className];
          return HieroglyphResult(
            arabicName: data['arabic_name'] ?? className,
            phonetic: data['phonetic'] ?? '',
            description: data['description'] ?? 'No description available.',
            confidence: maxProb,
          );
        } else {
          // Fallback if not in translations
          return HieroglyphResult(
            arabicName: className,
            phonetic: '',
            description: 'Translation data not found for this symbol.',
            confidence: maxProb,
          );
        }
      }
    } catch (e) {
      print("Error during inference: $e");
    }
    return null;
  }

  Future<Object?> _processImage(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      
      // Decode image using the image package
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;

      // Resize to 224x224
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // Normalization values
      final mean = [0.485, 0.456, 0.406];
      final std = [0.229, 0.224, 0.225];

      // Convert to Float32List and apply normalization
      var input = Float32List(1 * 224 * 224 * 3);
      var bufferIndex = 0;

      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = resizedImage.getPixel(x, y);
          
          input[bufferIndex++] = ((pixel.r.toDouble() / 255.0) - mean[0]) / std[0]; // Red
          input[bufferIndex++] = ((pixel.g.toDouble() / 255.0) - mean[1]) / std[1]; // Green
          input[bufferIndex++] = ((pixel.b.toDouble() / 255.0) - mean[2]) / std[2]; // Blue
        }
      }

      // Reshape to [1, 224, 224, 3] as expected by TFLite model
      return input.reshape([1, 224, 224, 3]);
    } catch (e) {
      print("Error processing image: $e");
      return null;
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
