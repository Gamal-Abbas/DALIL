import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> pickImageAndDetect() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image == null) return;

      // Stop camera stream if it's running
      _cameraController?.stopImageStream();
      _isDetecting = false;

      emit(ObjectDetectionLoading());

      final imageBytes = await image.readAsBytes();
      
      final decodedImage = await decodeImageFromList(imageBytes);
      final imageWidth = decodedImage.width.toDouble();
      final imageHeight = decodedImage.height.toDouble();

      final results = await repository.detectObjectsFromFile(imageBytes);

      emit(ObjectDetectionImageMode(
        imageBytes: imageBytes,
        detections: results,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
      ));
    } catch (e) {
      emit(ObjectDetectionError(e.toString()));
    }
  }

  void resumeCamera() {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      emit(ObjectDetectionReady(cameraController: _cameraController!));
      _startImageStream();
    } else {
      initialize();
    }
  }

  @override
  Future<void> close() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    repository.dispose();
    return super.close();
  }
}
