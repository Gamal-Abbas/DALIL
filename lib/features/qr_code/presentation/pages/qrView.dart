
import 'package:depi_dalil/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as ms;
import '../../../../core/utils/size.dart';
import '../../../ai_guide/data/models/baseModel.dart';
import '../../../ai_guide/presentation/pages/dispatcher.dart';
import '../manager/qrBloc.dart';
import '../manager/qrState.dart';
import '../widgets/scanInstruction.dart';
import '../widgets/sides.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late final ms.MobileScannerController cameraController;

  @override
  void initState() {
    cameraController = ms.MobileScannerController(torchEnabled: true);
    // TODO: implement initState
    super.initState();
  }

  double height = 0;
  double width = 0;
  double containerHeight = 0;
  double containerWidth = 0;
  double containerBorderRaduis = 0;
  double containerBorderWidth = 0;
  double appBarItemSize = 0;

  // double appBarFontSize=0;
  double appBarHeight = 0;

  @override
  void didChangeDependencies() {
    height = context.screenHeight;
    width = context.screenWidth;

    containerWidth = (width / 1.3).clamp(280, 900);
    containerHeight = (width / 2).clamp(280, 900);
    containerBorderRaduis = (height / 85).clamp(10, 15);
    containerBorderWidth = (height / 700).clamp(1, 1.7);
    appBarItemSize = (width / 16).clamp(35, 100);
    // appBarFontSize=(width / 16).clamp(20, 80);
    appBarHeight = (height / 12).clamp(35, 140);
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);

    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return qrBloc();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: context.scaffoldBg,
        appBar: appbar(),
        body: Stack(
          children: [
            BlocListener<qrBloc, QrState>(
              listener: (context, state) {},
              child: ms.MobileScanner(
                controller: cameraController,

                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                    cameraController.stop();

                    context.read<qrBloc>().processCode(
                      barcodes.first.rawValue!,
                      cameraController,
                    );
                  }
                },
              ),
            ),

            Container(color: Colors.black45),

            Center(
              child: Column(
                spacing: (height / 20),

                ///40
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: containerWidth, //300
                    height: containerHeight, //300
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.primary,
                        // .withOpacity(0.5)
                        width: containerBorderWidth, //1
                      ),
                      borderRadius: BorderRadius.circular(
                        containerBorderRaduis,

                        //10
                      ),
                    ),

                    child: const Sides(),
                  ),
                  const ScanInstruction(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget appbar() {
    return AppBar(
      toolbarHeight: appBarHeight,
      title: Text(
        "DALIL Scanner",
        style: TextStyle(
          fontSize: appBarItemSize,
          color: context.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        BlocConsumer<qrBloc, QrState>(
          listener: (context, state) {
            if (state is QrSucces) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtifactDetailsScreen(
                    data: BaseModel.fromJson(state.data),
                  ),
                ),
              ).then((value) => cameraController.start());
            } else if (state is QrLoading) {
              CircularProgressIndicator();
            }
          },
          buildWhen: (p, c) {
            return p != c;
          },
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                Icons.photo_library,
                color: context.primary,
                size: appBarItemSize,
              ),

              onPressed: () async {
                await context.read<qrBloc>().scanFromGallery(
                  controller: cameraController,
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.flash_on,
            color: context.primary,
            size: appBarItemSize, //35
          ),
          onPressed: () => cameraController.toggleTorch(),
        ),
      ],
    );
  }
}
