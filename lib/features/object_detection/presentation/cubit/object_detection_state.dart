import 'dart:typed_data';
import 'package:camera/camera.dart';
import '../../domain/entities/detection_result.dart';

import 'package:flutter/material.dart';

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

class ObjectDetectionImageMode extends ObjectDetectionState {
  final Uint8List imageBytes;
  final List<DetectionResult> detections;
  final double imageWidth;
  final double imageHeight;

  ObjectDetectionImageMode({
    required this.imageBytes,
    required this.detections,
    required this.imageWidth,
    required this.imageHeight,
  });
}
