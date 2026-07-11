import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dalil/features/hieroglyphics_decoder/presentation/manager/hieroglyphics_decoder_cubit.dart';
import 'package:dalil/features/hieroglyphics_decoder/presentation/manager/hieroglyphics_decoder_state.dart';
import 'package:dalil/features/hieroglyphics_decoder/presentation/widgets/bounding_box_painter.dart';
import 'package:dalil/features/hieroglyphics_decoder/presentation/widgets/detected_symbols_list.dart';
import 'package:dalil/features/hieroglyphics_decoder/presentation/widgets/image_source_selector.dart';
import 'package:dalil/features/hieroglyphics_decoder/presentation/widgets/symbol_bottom_sheet.dart';

class HieroglyphicsDecoderPage extends StatefulWidget {
  const HieroglyphicsDecoderPage({super.key});

  @override
  State<HieroglyphicsDecoderPage> createState() =>
      _HieroglyphicsDecoderPageState();
}

class _HieroglyphicsDecoderPageState extends State<HieroglyphicsDecoderPage> {
  final ImagePicker _picker = ImagePicker();
  int? _selectedDetectionIndex;
  ui.Image? _decodedImage;

  @override
  void initState() {
    super.initState();
    context.read<HieroglyphicsDecoderCubit>().initializeModel();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final xFile = await _picker.pickImage(source: source, imageQuality: 90);
      if (xFile != null && mounted) {
        _selectedDetectionIndex = null;
        _decodedImage = null;
        await context
            .read<HieroglyphicsDecoderCubit>()
            .processImage(File(xFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e',
                style: GoogleFonts.cairo()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _decodeImageSize(File imageFile) async {
    if (_decodedImage != null) return;
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    _decodedImage = frame.image;
    if (mounted) setState(() {});
  }

  void _onSymbolTap(int index) {
    final state = context.read<HieroglyphicsDecoderCubit>().state;
    if (state is DecoderSuccess) {
      setState(() => _selectedDetectionIndex = index);
      final detection = state.detections[index];
      final details = state.symbolDetails[detection.label];
      SymbolBottomSheet.show(
        context,
        detection: detection,
        details: details,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Hieroglyphics Decoder',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w800),
        ),
        actions: [
          BlocBuilder<HieroglyphicsDecoderCubit, HieroglyphicsDecoderState>(
            builder: (context, state) {
              if (state is DecoderSuccess || state is Ready) {
                return IconButton(
                  onPressed: () {
                    context.read<HieroglyphicsDecoderCubit>().reset();
                    setState(() {
                      _selectedDetectionIndex = null;
                      _decodedImage = null;
                    });
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Reset',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<HieroglyphicsDecoderCubit, HieroglyphicsDecoderState>(
        listener: (context, state) {
          if (state is DecoderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: GoogleFonts.cairo()),
                backgroundColor: colorScheme.error,
              ),
            );
          }
          if (state is DecoderSuccess) {
            _decodeImageSize(state.imageFile);
          }
        },
        builder: (context, state) {
          return switch (state) {
            Initial() || LoadingModel() => _buildLoadingModelState(context),
            Ready() => _buildReadyState(context),
            Processing() => _buildProcessingState(context),
            DecoderSuccess() => _buildSuccessState(context, state),
            DecoderError() => _buildErrorState(context, state),
          };
        },
      ),
    );
  }

  Widget _buildLoadingModelState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 24),
          Text(
            'Loading AI Model...',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Preparing hieroglyphic recognition engine',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ready to Decode',
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Choose an image from camera or gallery to detect hieroglyphic symbols',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ImageSourceSelector(
            onCameraTap: () => _pickImage(ImageSource.camera),
            onGalleryTap: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 24),
          Text(
            'Analyzing Image...',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Detecting hieroglyphic symbols',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, DecoderSuccess state) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${state.detections.length} symbol${state.detections.length != 1 ? 's' : ''} detected',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildImageView(context, state),
              ],
            ),
          ),
        ),
        DetectedSymbolsList(
          detections: state.detections,
          onSymbolTap: _onSymbolTap,
          selectedIndex: _selectedDetectionIndex,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<HieroglyphicsDecoderCubit>().reset();
                setState(() {
                  _selectedDetectionIndex = null;
                  _decodedImage = null;
                });
              },
              icon: const Icon(Icons.camera_alt_rounded, size: 20),
              label: Text(
                'New Image',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageView(BuildContext context, DecoderSuccess state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageWidth = _decodedImage?.width.toDouble() ?? 1.0;
        final imageHeight = _decodedImage?.height.toDouble() ?? 1.0;
        final displayHeight =
            (constraints.maxWidth / imageWidth) * imageHeight;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: double.infinity,
              height: displayHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    state.imageFile,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  if (_decodedImage != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BoundingBoxPainter(
                          detections: state.detections,
                          imageSize: Size(imageWidth, imageHeight),
                          widgetSize: Size(
                            constraints.maxWidth,
                            displayHeight,
                          ),
                          selectedIndex: _selectedDetectionIndex,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, DecoderError state) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                context.read<HieroglyphicsDecoderCubit>().initializeModel();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                'Try Again',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
