import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide Barcode, BarcodeFormat;

/// A professional barcode scanner supporting live camera and gallery images.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController();
  final ImagePicker _picker = ImagePicker();

  Barcode? _lastBarcode;
  bool _isGalleryLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _controller.stop();
        break;
      case AppLifecycleState.resumed:
        _controller.start();
        break;
      default:
        break;
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (!mounted) return;
    setState(() {
      _lastBarcode = capture.barcodes.firstOrNull as Barcode?;
    });
  }

  Future<void> _pickAndScanImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;

    setState(() => _isGalleryLoading = true);

    try {
      final BarcodeCapture? capture = await _controller.analyzeImage(image.path);

      if (!mounted) return;

      if (capture != null && capture.barcodes.isNotEmpty) {
        setState(() {
          _lastBarcode = capture.barcodes.first as Barcode?;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Found: ${capture.barcodes.first.displayValue ?? "N/A"}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No barcode found in the image.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGalleryLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Scanner view with error handling
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Scan frame overlay (cosmetic)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Top bar: torch, camera switch, gallery button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(
                  icon: Icons.photo_library_rounded,
                  onPressed: _isGalleryLoading ? null : _pickAndScanImage,
                ),
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _controller,
                      builder: (context, state, _) => _buildIconButton(
                        icon: state.torchState == TorchState.on
                            ? Icons.flash_on
                            : Icons.flash_off,
                        onPressed: () => _controller.toggleTorch(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ValueListenableBuilder(
                      valueListenable: _controller,
                      builder: (context, state, _) => _buildIconButton(
                        icon: Icons.flip_camera_android_rounded,
                        onPressed: () => _controller.switchCamera(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom result panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _ResultPanel(
              barcode: _lastBarcode,
              isLoading: _isGalleryLoading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildErrorWidget(MobileScannerException error) {
    String message;
    IconData icon;

    switch (error.errorCode) {
      case MobileScannerErrorCode.permissionDenied:
        message = 'Camera permission denied. Please grant access in settings.';
        icon = Icons.no_photography;
        break;
      case MobileScannerErrorCode.unsupported:
        message = 'Scanning is not supported on this device.';
        icon = Icons.error_outline;
        break;
      default:
        message = 'An unexpected error occurred: ${error.errorDetails?.message}';
        icon = Icons.error;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays the last scanned barcode with a copy button.
class _ResultPanel extends StatelessWidget {
  final Barcode? barcode;
  final bool isLoading;

  const _ResultPanel({required this.barcode, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final displayValue = barcode?.displayValue;
    final hasData = displayValue != null && displayValue.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: hasData || isLoading ? 100 : 56,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
            : hasData
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  displayValue,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.white70),
              tooltip: 'Copy to clipboard',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: displayValue));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
          ],
        )
            : const Text(
          'Point the camera at a barcode or pick an image from the gallery.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}