import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/hieroglyph_ai_service.dart';

// DALIL Premium Color Palette
class DalilColors {
  static const Color richBlack = Color(0xFF101010);
  static const Color matteGold = Color(0xFFFFD700);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color glassBackground = Color(0x66101010);
}

class DalilScanScreen extends StatefulWidget {
  const DalilScanScreen({super.key});

  @override
  State<DalilScanScreen> createState() => _DalilScanScreenState();
}

class _DalilScanScreenState extends State<DalilScanScreen> {
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();
  final HieroglyphAiService _aiService = HieroglyphAiService();

  @override
  void initState() {
    super.initState();
    _aiService.init();
  }

  Future<void> _onCapture() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() => _isProcessing = true);
        final result = await _aiService.predict(image.path);
        if (mounted) {
          setState(() => _isProcessing = false);
          if (result != null) {
            _showTranslationCard(
              context,
              arabicName: result.arabicName,
              phonetic: result.phonetic,
              description: result.description,
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error capturing image: $e");
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _onGalleryPick() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _isProcessing = true);
        final result = await _aiService.predict(image.path);
        if (mounted) {
          setState(() => _isProcessing = false);
          if (result != null) {
            _showTranslationCard(
              context,
              arabicName: result.arabicName,
              phonetic: result.phonetic,
              description: result.description,
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: DalilColors.richBlack,
      body: Stack(
        children: [
          // 1. App Title (Subtle & Elegant)
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "DALIL",
                style: GoogleFonts.marcellus(
                  color: DalilColors.matteGold,
                  fontSize: 28,
                  letterSpacing: 8,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // 2. Central Camera Viewport
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: DalilColors.matteGold.withOpacity(0.5),
                  width: 1.2,
                ),
              ),
              child: Stack(
                children: [
                  // Simulated Camera Feed Background
                  Container(
                    color: Colors.white.withOpacity(0.03),
                    child: Center(
                      child: Icon(
                        Icons.filter_center_focus_outlined,
                        color: DalilColors.matteGold.withOpacity(0.2),
                        size: 40,
                      ),
                    ),
                  ),
                  // Corner Brackets for that 'Scanner' look
                  ..._buildCorners(),
                ],
              ),
            ),
          ),

          // 3. Control Bar
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Upload from Gallery
                IconButton(
                  onPressed: _onGalleryPick,
                  icon: const Icon(Icons.photo_library_outlined),
                  color: DalilColors.matteGold,
                  iconSize: 28,
                ),
                const SizedBox(width: 40),
                // Main Capture Button
                GestureDetector(
                  onTap: _isProcessing ? null : _onCapture,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: DalilColors.matteGold,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isProcessing
                            ? Colors.transparent
                            : DalilColors.matteGold,
                      ),
                      child: _isProcessing
                          ? const Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: DalilColors.matteGold,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              color: DalilColors.richBlack,
                              size: 32,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 68,
                ), // Spacing to balance the gallery icon
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    return [
      _corner(top: 0, left: 0),
      _corner(top: 0, right: 0, rotate: 1),
      _corner(bottom: 0, left: 0, rotate: 3),
      _corner(bottom: 0, right: 0, rotate: 2),
    ];
  }

  Widget _corner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    int rotate = 0,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: RotatedBox(
        quarterTurns: rotate,
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: DalilColors.matteGold, width: 3),
              left: BorderSide(color: DalilColors.matteGold, width: 3),
            ),
          ),
        ),
      ),
    );
  }

  void _showTranslationCard(BuildContext context, {
    required String arabicName,
    required String phonetic,
    required String description,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DalilTranslationCard(
        arabicName: arabicName,
        phonetic: phonetic,
        description: description,
      ),
    );
  }
}

class DalilTranslationCard extends StatelessWidget {
  final String arabicName;
  final String phonetic;
  final String description;

  const DalilTranslationCard({
    super.key,
    required this.arabicName,
    required this.phonetic,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 48),
        decoration: BoxDecoration(
          color: DalilColors.glassBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border.all(
            color: DalilColors.matteGold.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: DalilColors.matteGold.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Arabic Name
            Text(
              arabicName,
              style: GoogleFonts.cairo(
                color: DalilColors.offWhite,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Phonetic Spelling
            Text(
              "Phonetic: $phonetic",
              style: GoogleFonts.marcellus(
                color: DalilColors.matteGold,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.2,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(color: Colors.white10),
            ),

            // Description
            Text(
              "HISTORICAL SIGNIFICANCE",
              style: GoogleFonts.marcellus(
                color: DalilColors.matteGold.withOpacity(0.6),
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.inter(
                color: DalilColors.offWhite.withOpacity(0.9),
                fontSize: 16,
                height: 1.7,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
