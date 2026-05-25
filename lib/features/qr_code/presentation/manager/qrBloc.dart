import 'package:depi_dalil/features/qr_code/presentation/manager/qrState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../notifications/domain/usecases/firebase_service.dart';

class qrBloc extends Cubit<qrState> {
  qrBloc() : super(qrInit());

  final List<Map<String, String>> artifactsData = [
    {
      "id": "king_2",
      "name": "قناع توت عنخ آمون",
      "desc": "قناع جنائزي ذهبي للملك توت عنخ آمون من الأسرة الـ 18.",
    },

    {
      "id": "king_3",
      "name": "قناع توت عنخ آمون",
      "desc": "قناع جنائزي ذهبي للملك توت عنخ آمون من الأسرة الـ 18.",
    },

    {
      "id": "nefertiti",
      "name": "تمثال نفرتيتي",
      "desc": "تمثال نصفي للملكة نفرتيتي، زوجة الفرعون إخناتون.",
    },
    {
      "id": "https://qrco.de/bgjv2W",
      "name": "زياد طه",
      "desc": "Ziad Taha \nHe is human And from The Earth wooow",
    },
    {
      "id": "https://randomqr.com",
      "name": "كود تجريبي",
      "desc": "هذا الكود تم قراءته بنجاح من الموقع العشوائي",
    },
  ];

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
        emit(qrSucces(data: result));
      } else {
        print("Code not found in Firebase: $cleanCode");
        emit(qrInit());
        cameraController?.start();
      }
    } catch (e) {
      print("Error in processCode: ${e.toString()}");
      print("Code not found: $cleanCode");
      emit(qrInit());
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

      emit(qrLoading());
      await controller.stop();
      final stopCameraTime = stopwatch.elapsedMilliseconds;

      final analysisStart = stopwatch.elapsedMilliseconds;

      await controller.stop();

      await Future.delayed(const Duration(milliseconds: 250));

      final BarcodeCapture? capture = await controller.analyzeImage(image.path);
      final analysisEnd = stopwatch.elapsedMilliseconds; //
      // final String imagePath = image.path;
      // // تشغيل عملية التحليل في Isolate منفصل
      // final BarcodeCapture? capture = await Isolate.run(() async {
      //   // هنا نقوم بعملية التحليل الثقيلة
      //   return await controller.analyzeImage(imagePath);
      // });
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
        emit(qrInit());

        await controller.start();
      }
    } catch (e) {
      print("Error: $e");
      emit(qrInit());
      if (!controller.value.isRunning) await controller.start();
    }
  }
}

//
// import 'dart:isolate';
// import 'package:dalil/core/bloc/QR/qrState.dart';
// import 'package:dalil/notifications/notifications2/firebaseManager.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mobile_scanner/mobile_scanner.dart' hide Barcode;
// import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
//

// Future<String?> _analyzeImageWithMLKit(String path) async {
//   final barcodeScanner = BarcodeScanner();
//   final inputImage = InputImage.fromFilePath(path);
//
//   try {
//     final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
//     if (barcodes.isNotEmpty) {
//       return barcodes.first.rawValue;
//     }
//     return null;
//   } catch (e) {
//     return null;
//   } finally {

//     await barcodeScanner.close();
//   }
// }
//
// class qrBloc extends Cubit<qrState> {
//   qrBloc() : super(qrInit());
//

//   final List<Map<String, String>> artifactsData = [

//   ];
//
//   Future<void> processCode(String? code, MobileScannerController? cameraController) async {
//     if (code == null || code.isEmpty) return;
//
//     String cleanCode = code;

//     if (cleanCode.length > 2) {
//       cleanCode = cleanCode.substring(1, cleanCode.length - 1);
//     }
//
//     try {
//       var result = await FireBaseManager.getSpecificData(id: cleanCode);
//       if (result != null) {
//         emit(qrSucces(data: result));
//       } else {
//         emit(qrInit());
//         cameraController?.start();
//       }
//     } catch (e) {
//       emit(qrInit());
//       cameraController?.start();
//     }
//   }
//
//   Future<void> scanFromGallery({required MobileScannerController controller}) async {
//     final picker = ImagePicker();
//
//     try {
//
//
//       final XFile? image = await picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 600,
//         maxHeight: 600,
//         imageQuality: 50
//
//       );
//
//       if (image == null) return;
//       final stopwatch = Stopwatch()..start();
//       emit(qrLoading());
//
//       controller.stop();
//       final stopCameraTime = stopwatch.elapsedMilliseconds;
//       emit(qrLoading());
//
//       controller.stop();
//       final analysisStart = stopwatch.elapsedMilliseconds;

//       final barcodeScanner = BarcodeScanner();
//       final inputImage = InputImage.fromFilePath(image.path);
//
//       final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
//       await barcodeScanner.close();
//       final analysisEnd = stopwatch.elapsedMilliseconds;
//       await barcodeScanner.close();
//       if (barcodes.isNotEmpty) {
//         final String? codeValue = barcodes.first.rawValue;
//         if (codeValue != null) {

//           await processCode(codeValue, null);
//
//           stopwatch.stop();
//
//           print("--- [ML Kit Method Results] ---");
//           print("Total Time: ${stopwatch.elapsedMilliseconds} ms");
//           print("Camera Stop call took: $stopCameraTime ms");
//           print("Analysis took: ${analysisEnd - analysisStart} ms");
//           print("-------------------------------");
//         }
//       } else {
//         emit(qrInit());

//       }
//     } catch (e) {
//       print("Error: $e");
//       emit(qrInit());
//       controller.start();
//     }
//   }}
//
//
//
//
//
//
//
//
//

////////////// wronge

// import 'dart:isolate';
// import 'package:dalil/core/bloc/QR/qrState.dart';
// import 'package:dalil/notifications/notifications2/firebaseManager.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mobile_scanner/mobile_scanner.dart' hide Barcode;
// // المكتبة الجديدة
// import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
//
// // 1. الدالة دي لازم تكون بره الكلاس عشان الـ Isolate يشتغل صح
// // دي اللي بتعمل الشغل التقيل بعيد عن الـ UI
// Future<String?> _analyzeImageWithMLKit(String path) async {
//   final barcodeScanner = BarcodeScanner();
//   final inputImage = InputImage.fromFilePath(path);
//
//   try {
//     final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
//     if (barcodes.isNotEmpty) {
//       return barcodes.first.rawValue;
//     }
//     return null;
//   } catch (e) {
//     return null;
//   } finally {
//     // مهم جداً نقفل السكنر عشان م يستهلكش رامات
//     await barcodeScanner.close();
//   }
// }
//
// class qrBloc extends Cubit<qrState> {
//   qrBloc() : super(qrInit());
//
//   // البيانات التجريبية (Artifacts Data) كما هي...
//   final List<Map<String, String>> artifactsData = [
//     // ... القائمة الخاصة بك
//   ];
//
//   Future<void> processCode(String? code, MobileScannerController? cameraController) async {
//     if (code == null || code.isEmpty) return;
//
//     String cleanCode = code;
//     // منطق التنظيف الخاص بك (تأكد من صحة الـ Substring حسب شكل الكود عندك)
//     if (cleanCode.length > 2) {
//       cleanCode = cleanCode.substring(1, cleanCode.length - 1);
//     }
//
//     try {
//       var result = await FireBaseManager.getSpecificData(id: cleanCode);
//       if (result != null) {
//         emit(qrSucces(data: result));
//       } else {
//         emit(qrInit());
//         cameraController?.start();
//       }
//     } catch (e) {
//       emit(qrInit());
//       cameraController?.start();
//     }
//   }
//
//   Future<void> scanFromGallery({required MobileScannerController controller}) async {
//     final picker = ImagePicker();
//
//     try {
//       // اختيار الصورة مع تصغير مبدئي للسرعة
//       final XFile? image = await picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1000,
//         maxHeight: 1000,
//       );
//
//       if (image == null) return;
//
//       emit(qrLoading());
//
//       // 1. وقف الكاميرا عشان نخفف الجهد عن المعالج
//       await controller.stop();
//
//       // 2. تشغيل الـ Isolate للتحليل (هنا السر في السرعة وعدم الـ Lag)
//       final String imagePath = image.path;
//       final String? codeValue = await Isolate.run(() => _analyzeImageWithMLKit(imagePath));
//
//       if (codeValue != null) {
//         print("DATA FOUND IN ISOLATE: $codeValue");
//         await processCode(codeValue, null);
//       } else {
//         print("No QR found in image");
//         emit(qrInit());
//         await controller.start();
//       }
//     } catch (e) {
//       print("Error in gallery scan: $e");
//       emit(qrInit());
//       if (!controller.value.isRunning) await controller.start();
//     }
//   }
// }
