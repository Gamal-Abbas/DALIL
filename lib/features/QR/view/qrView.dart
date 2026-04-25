import 'package:dalil/core/bloc/QR/qrBloc.dart';
import 'package:dalil/core/bloc/QR/qrState.dart';
import 'package:dalil/core/constants/app_color.dart';
import 'package:dalil/features/ArtifactDetails/data/model/baseModel.dart';
import 'package:dalil/features/ArtifactDetails/view/dispatcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as ms;

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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);

    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SH = size.height;
    final SW = size.width;

    const Color pharaohGold = Color(0xFFFFD700);
    const Color pharaohBrown = Color(0xFF8B4513);
    const Color pharaohBlack = Color(0xFF1A1A1A);

    return BlocProvider(
      create: (context) {
        return qrBloc();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: pharaohBlack,
        appBar: appbar(SH: SH, SW: SW, pharaohGold: pharaohGold),
        body: Stack(
          children: [
            BlocListener<qrBloc, qrState>(
              listener: (context, state) {},
              child: ms.MobileScanner(
                controller: cameraController,
                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    /////////////
                    context.read<qrBloc>().processCode(
                      barcodes.first.rawValue,
                      cameraController,
                    );
                  }
                },
              ),
            ),

            Container(color: Colors.black.withOpacity(0.7)),

            Center(
              child: Column(
                spacing: (SH / 20),
                ///40
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: (SW / 1.3).clamp(280, 900), //300
                    height: (SW / 2).clamp(280, 900), //300
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: pharaohGold.withOpacity(0.5),
                        width: (SH / 700).clamp(1, 1.7), //1
                      ),
                      borderRadius: BorderRadius.circular(
                        (SH / 85).clamp(10, 15),

                        //10
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: _buildPharaohCorner(
                            SH: SH,
                            top: true,
                            left: true,
                            color: pharaohGold,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: _buildPharaohCorner(
                            top: true,
                            SH: SH,
                            left: false,
                            color: pharaohGold,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: _buildPharaohCorner(
                            top: false,
                            SH: SH,
                            left: true,
                            color: pharaohGold,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: _buildPharaohCorner(
                            top: false,
                            SH: SH,
                            left: false,
                            color: pharaohGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "scan_instruction".tr(),
                    style: TextStyle(
                      color: pharaohGold,
                      fontSize: (SH / 40).clamp(16, 48),
                      ///18
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 15, color: Colors.black)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPharaohCorner({
    required bool top,
    required bool left,
    required Color color,
    required double SH,
  }) {
    double cornerSize = (SH / 18).clamp(40, 60);
    ///40
    double cornerThickness = (SH / 160).clamp(5, 20);
    ///5
    return Container(
      width: cornerSize,
      height: cornerSize,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? BorderSide(color: color, width: cornerThickness)
              : BorderSide.none,
          bottom: !top
              ? BorderSide(color: color, width: cornerThickness)
              : BorderSide.none,
          left: left
              ? BorderSide(color: color, width: cornerThickness)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: color, width: cornerThickness)
              : BorderSide.none,
        ),
      ),
    );
  }

  PreferredSizeWidget appbar({
    required double SW,
    required double SH,
    required Color pharaohGold,
  }) {
    return AppBar(
      toolbarHeight: (SH / 12).clamp(35, 140),
      title: Text(
        "DALIL Scanner",
        style: TextStyle(
          fontSize: (SW / 16).clamp(20, 80),
          color: pharaohGold,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        BlocConsumer<qrBloc, qrState>(
          listener: (context, state) {
            if (state is qrSucces) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtifactDetailsScreen(
                    data: BaseModel.fromJson(state.data),
                  ),
                ),
              ).then((value) => cameraController.start());
            } else if (state is qrLoading) {
              CircularProgressIndicator();
            }
          },

          builder: (context, state) {
            return IconButton(
              icon: Icon(
                Icons.photo_library,
                color: AppColors.secondary,
                size: (SW / 16).clamp(30, 100),
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
            color: AppColors.secondary,
            size: (SW / 16).clamp(35, 100), //35
          ),
          onPressed: () => cameraController.toggleTorch(),
        ),
      ],
    );
  }
}
