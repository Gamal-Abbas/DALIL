import 'package:depi_dalil/features/qr_code/presentation/manager/qrState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../notifications/data/datasources/firebase_service.dart';


class qrBloc extends Cubit<QrState> {
  qrBloc() : super(QrInit());


  Future<void> processCode(
    String? code,
    MobileScannerController? cameraController,
  ) async {
    if (code == null || code.isEmpty) return;

    String cleanCode = code;

    print('DAta=$cleanCode'); // king_2 in barcode then result=king only

    // "king_2" in barcode and i remove " " from string and take success id
    cleanCode = cleanCode.substring(1, cleanCode.length - 1);
    print('DAta after process=$cleanCode');

    try {
      var result = await FirebaseService.getDataFromFirebase_By_Id(
        id: cleanCode,
      );

      print('result=$result');

      if (result != null) {
        emit(QrSucces(data: result));
      } else {
        print("Code not found in Firebase: $cleanCode");
        emit(QrInit());
        cameraController?.start();
      }
    } catch (e) {
      print("Error in processCode: ${e.toString()}");
      print("Code not found: $cleanCode");
      emit(QrInit());
      cameraController?.start();
    }
  }

  Future<void> scanFromGallery({
    required MobileScannerController controller,
  }) async {
    final picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,

        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );
      if (image == null) return;
      final stopwatch = Stopwatch()..start();

      emit(QrLoading());
      await controller.stop();
      final stopCameraTime = stopwatch.elapsedMilliseconds;

      final analysisStart = stopwatch.elapsedMilliseconds;

      await controller.stop();

      await Future.delayed(const Duration(milliseconds: 250));

      final BarcodeCapture? capture = await controller.analyzeImage(image.path);
      final analysisEnd = stopwatch.elapsedMilliseconds; //

      if (capture != null && capture.barcodes.isNotEmpty) {
        final String? codeValue = capture.barcodes.first.rawValue;
        if (codeValue != null) {
          print("RAW DATA FROM SCANNER: ${capture.barcodes.first.rawValue}");
          // processCode(capture.barcodes.first.rawValue, null);
          await processCode(codeValue, null);

          stopwatch.stop();

          print("--- [Standard Method Results] ---");
          print("Total Time: ${stopwatch.elapsedMilliseconds} ms");
          print("Camera Stop took: $stopCameraTime ms");
          print("Analysis took: ${analysisEnd - analysisStart} ms");
          print("---------------------------------");
        }
      } else {
        print("No QR found - Try again with a clearer image");
        emit(QrInit());

        await controller.start();
      }
    } catch (e) {
      print("Error: $e");
      emit(QrInit());
      if (!controller.value.isRunning) await controller.start();
    }
  }
}
