import os

files = {
    'lib/features/object_detection/presentation/pages/object_detection_page.dart': """import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../cubit/object_detection_cubit.dart';
import '../cubit/object_detection_state.dart';
import '../widgets/bounding_box_painter.dart';

class ObjectDetectionPage extends StatelessWidget {
  const ObjectDetectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: BlocBuilder<ObjectDetectionCubit, ObjectDetectionState>(
        builder: (context, state) {
          if (state is ObjectDetectionLoading || state is ObjectDetectionInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD4AF37),
                strokeWidth: 2,
              ),
            );
          } else if (state is ObjectDetectionError) {
            return _buildErrorState(context, state.message);
          } else if (state is ObjectDetectionReady) {
            return _buildReadyState(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white54, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () => context.read<ObjectDetectionCubit>().initialize(),
            child: const Text('RETRY'),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyState(BuildContext context, ObjectDetectionReady state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(state.cameraController),
        
        CustomPaint(
          painter: BoundingBoxPainter(state.detections),
        ),
        
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, bottom: 24, left: 24, right: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF101010).withOpacity(0.9),
                  const Color(0xFF101010).withOpacity(0.0),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  ),
                ),
                const Text(
                  'SMART GUIDE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 48, bottom: 48, left: 24, right: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF101010).withOpacity(0.95),
                  const Color(0xFF101010).withOpacity(0.0),
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.center_focus_strong, color: Color(0xFFD4AF37), size: 32),
                SizedBox(height: 16),
                Text(
                  'Scanning for Monuments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Point your camera at a historical monument\nto identify it in real-time.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
""",
    'lib/features/object_detection/presentation/cubit/object_detection_cubit.dart': """import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/object_detection_repository.dart';
import 'object_detection_state.dart';

class ObjectDetectionCubit extends Cubit<ObjectDetectionState> {
  final ObjectDetectionRepository repository;
  CameraController? _cameraController;
  bool _isDetecting = false;

  ObjectDetectionCubit({required this.repository}) : super(ObjectDetectionInitial());

  Future<void> initialize() async {
    emit(ObjectDetectionLoading());
    try {
      await repository.initializeModel();

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        emit(ObjectDetectionError('No cameras available'));
        return;
      }

      final camera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      emit(ObjectDetectionReady(cameraController: _cameraController!));

      _startImageStream();
    } catch (e) {
      emit(ObjectDetectionError(e.toString()));
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      try {
        final results = await repository.detectObjects(image);
        
        if (state is ObjectDetectionReady) {
          emit((state as ObjectDetectionReady).copyWith(detections: results));
        }
      } catch (e) {
        // Silently handle stream errors or log them
      } finally {
        _isDetecting = false;
      }
    });
  }

  @override
  Future<void> close() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    repository.dispose();
    return super.close();
  }
}
""",
    'lib/features/object_detection/presentation/cubit/object_detection_state.dart': """import 'package:camera/camera.dart';
import '../../domain/entities/detection_result.dart';

abstract class ObjectDetectionState {}

class ObjectDetectionInitial extends ObjectDetectionState {}

class ObjectDetectionLoading extends ObjectDetectionState {}

class ObjectDetectionReady extends ObjectDetectionState {
  final CameraController cameraController;
  final List<DetectionResult> detections;

  ObjectDetectionReady({
    required this.cameraController,
    this.detections = const [],
  });

  ObjectDetectionReady copyWith({
    CameraController? cameraController,
    List<DetectionResult>? detections,
  }) {
    return ObjectDetectionReady(
      cameraController: cameraController ?? this.cameraController,
      detections: detections ?? this.detections,
    );
  }
}

class ObjectDetectionError extends ObjectDetectionState {
  final String message;
  ObjectDetectionError(this.message);
}
""",
    'lib/features/object_detection/utils/image_utils.dart': """import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  static Float32List cameraImageToFloat32List(CameraImage image, int inputSize) {
    img.Image? convertedImage;

    if (image.format.group == ImageFormatGroup.yuv420) {
      convertedImage = _convertYUV420(image);
    } else if (image.format.group == ImageFormatGroup.bgra8888) {
      convertedImage = _convertBGRA8888(image);
    }

    if (convertedImage == null) return Float32List(0);

    final img.Image resizedImage = img.copyResize(convertedImage, width: inputSize, height: inputSize);
    return _imageToFloat32List(resizedImage, inputSize);
  }

  static img.Image _convertBGRA8888(CameraImage image) {
    return img.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      order: img.ChannelOrder.bgra,
    );
  }

  static img.Image _convertYUV420(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final uvRowStride = image.planes[1].bytesPerRow;
    final uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

    final imgImage = img.Image(width: width, height: height);

    for (var y = 0; y < height; y++) {
      var pY = y * image.planes[0].bytesPerRow;
      var pUV = (y >> 1) * uvRowStride;

      for (var x = 0; x < width; x++) {
        final uvIndex = pUV + (x >> 1) * uvPixelStride;

        final yp = image.planes[0].bytes[pY];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];

        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        imgImage.setPixelRgb(x, y, r, g, b);
        pY++;
      }
    }
    return imgImage;
  }

  static Float32List _imageToFloat32List(img.Image image, int inputSize) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = pixel.r / 255.0;
        buffer[pixelIndex++] = pixel.g / 255.0;
        buffer[pixelIndex++] = pixel.b / 255.0;
      }
    }
    return convertedBytes;
  }
}
""",
    'lib/features/object_detection/data/datasources/object_detection_local_data_source.dart': """import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../domain/entities/detection_result.dart';
import '../../utils/image_utils.dart';
import '../../utils/nms.dart';

abstract class ObjectDetectionLocalDataSource {
  Future<void> initialize();
  Future<List<DetectionResult>> detect(CameraImage image);
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
""",
    'lib/features/object_detection/data/repositories/object_detection_repository_impl.dart': """import 'package:camera/camera.dart';
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
  void dispose() {
    localDataSource.dispose();
  }
}
""",
    'lib/features/object_detection/domain/repositories/object_detection_repository.dart': """import 'package:camera/camera.dart';
import '../entities/detection_result.dart';

abstract class ObjectDetectionRepository {
  Future<void> initializeModel();
  Future<List<DetectionResult>> detectObjects(CameraImage image);
  void dispose();
}
"""
}

for path, content in files.items():
    with open(path, 'w') as f:
        f.write(content)

