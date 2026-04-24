import 'package:dalil/core/bloc/QR/qrState.dart';
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

  void processCode(String? code, MobileScannerController? cameraController) {
    final cleanCode = code?.trim();
    if (cleanCode == null || cleanCode.isEmpty) return;

    cameraController?.stop();

    try {
      final result = artifactsData.firstWhere(
            (e) => e['id'] == cleanCode,
      );

      emit(qrSucces(data: result));
    } catch (e) {
      print("Code not found: $cleanCode");
      cameraController?.start();
    }
  }

  Future<void> scanFromGallery() async {
    final picker = ImagePicker();
    final controller = MobileScannerController(

    );
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      emit(qrLoading());

      final BarcodeCapture? capture = await controller.analyzeImage(image.path);

      if (capture != null && capture.barcodes.isNotEmpty) {
        final String? codeValue = capture.barcodes.first.rawValue;
        processCode(codeValue, null);
      } else {
        print("No QR found in gallery image");
        emit(qrInit());
      }
    } catch (e) {
      print("Error scanning gallery with Mobile Scanner: $e");
      emit(qrInit());
    } finally {
      controller.dispose();
    }
  }
}