import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/hieroglyphic_symbol.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/detected_symbol.dart';

class SymbolBottomSheet extends StatelessWidget {
  final DetectedSymbol detection;
  final HieroglyphicSymbol? details;

  const SymbolBottomSheet({
    super.key,
    required this.detection,
    this.details,
  });

  static void show(
    BuildContext context, {
    required DetectedSymbol detection,
    HieroglyphicSymbol? details,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SymbolBottomSheet(
        detection: detection,
        details: details,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.emoji_symbols_rounded,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        details?.english ??
                            detection.label.replaceAll('_', ' '),
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  context,
                  title: 'Pronunciation',
                  body: details?.pronunciation ?? '---',
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Meaning',
                  body: details?.meaning ?? '---',
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Description',
                  body: details?.description ??
                      'No description available for this symbol.',
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String body,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          style: GoogleFonts.cairo(
            fontSize: 16,
            height: 1.6,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
