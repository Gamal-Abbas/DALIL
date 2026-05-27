import 'dart:typed_data';
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

  static Float32List fileImageToFloat32List(Uint8List imageBytes, int inputSize) {
    final img.Image? decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) return Float32List(0);
    final img.Image resizedImage = img.copyResize(decodedImage, width: inputSize, height: inputSize);
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
