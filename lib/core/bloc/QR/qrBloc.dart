import 'dart:math';

import 'package:dalil/core/bloc/QR/qrState.dart';
import 'package:dalil/notifications/notifications2/firebaseManager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

// 1. ضيف async للدالة
  Future<void> processCode(String? code, MobileScannerController? cameraController) async {
    if (code == null || code.isEmpty) return;

    String cleanCode = code ;

    print('DAta=$cleanCode');     // king_2 in barcode then result=king only

    // "king_2" in barcode and i remove " " from string and take success id
    cleanCode=cleanCode.substring(1,cleanCode.length-1);
    print('DAta after process=$cleanCode');

    try {

      var result = await FireBaseManager.getSpecificData(id: cleanCode);

      print('result=$result');


      if (result != null) {
        emit(qrSucces(data: result));
      } else {
        print("Code not found in Firebase: $cleanCode");
        emit(qrInit()); // أو أي State تعبر عن إن الكود مش موجود
        cameraController?.start();
      }
    } catch (e) {
      print("Error in processCode: ${e.toString()}");
      print("Code not found: $cleanCode");
      emit(qrInit());
      cameraController?.start();
    }
  }

  Future<void> scanFromGallery({required MobileScannerController controller}) async {
    final picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      emit(qrLoading());

      // 1. وقف الكاميرا خالص
      await controller.stop();

      // 2. انتظر ثانية واحدة (ده سر المهنة عشان الـ Buffer يلحق يتفضي)
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. التحليل
      final BarcodeCapture? capture = await controller.analyzeImage(image.path);

      if (capture != null && capture.barcodes.isNotEmpty) {
        final String? codeValue = capture.barcodes.first.rawValue;
        if (codeValue != null) {
          print("RAW DATA FROM SCANNER: ${capture.barcodes.first.rawValue}");
          // processCode(capture.barcodes.first.rawValue, null);
          processCode(codeValue, null);
          // هنا مش هنعمل start لأننا غالباً هنروح لصفحة تانية
        }
      } else {
        print("No QR found - Try again with a clearer image");
        emit(qrInit());
        // لو ملقاش، رجع الكاميرا تشتغل
        await controller.start();
      }

    } catch (e) {
      print("Error: $e");
      emit(qrInit());
      if (!controller.value.isRunning) await controller.start();
    }
  }}