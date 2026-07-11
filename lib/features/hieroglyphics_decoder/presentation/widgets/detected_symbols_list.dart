import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dalil/features/hieroglyphics_decoder/domain/entities/detected_symbol.dart';

class DetectedSymbolsList extends StatelessWidget {
  final List<DetectedSymbol> detections;
  final ValueChanged<int> onSymbolTap;
  final int? selectedIndex;

  const DetectedSymbolsList({
    super.key,
    required this.detections,
    required this.onSymbolTap,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (detections.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Text(
                'No symbols detected',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Try a clearer image or different angle',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: detections.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final detection = detections[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSymbolTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 120,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.15)
                    : colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant.withValues(alpha: 0.2),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getSymbolIcon(detection.label),
                    size: 26,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    detection.label.replaceAll('_', ' '),
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getSymbolIcon(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('eye')) return Icons.remove_red_eye_rounded;
    if (lowerLabel.contains('ankh') || lowerLabel.contains('life_spirit')) {
      return Icons.favorite_rounded;
    }
    if (lowerLabel.contains('bird') ||
        lowerLabel.contains('falcon') ||
        lowerLabel.contains('owl') ||
        lowerLabel.contains('duck') ||
        lowerLabel.contains('swallow')) {
      return Icons.pets_rounded;
    }
    if (lowerLabel.contains('snake') ||
        lowerLabel.contains('viper') ||
        lowerLabel.contains('cobra')) {
      return Icons.coronavirus_rounded;
    }
    if (lowerLabel.contains('man') ||
        lowerLabel.contains('woman') ||
        lowerLabel.contains('boy') ||
        lowerLabel.contains('mother')) {
      return Icons.person_rounded;
    }
    if (lowerLabel.contains('king') ||
        lowerLabel.contains('ruler') ||
        lowerLabel.contains('soldier')) {
      return Icons.emoji_events_rounded;
    }
    if (lowerLabel.contains('water') ||
        lowerLabel.contains('pool') ||
        lowerLabel.contains('canal')) {
      return Icons.water_rounded;
    }
    if (lowerLabel.contains('bread') || lowerLabel.contains('loaf')) {
      return Icons.lunch_dining_rounded;
    }
    if (lowerLabel.contains('star') || lowerLabel.contains('ring')) {
      return Icons.auto_awesome_rounded;
    }
    if (lowerLabel.contains('fish') || lowerLabel.contains('nile')) {
      return Icons.set_meal_rounded;
    }
    if (lowerLabel.contains('elephant') ||
        lowerLabel.contains('lion') ||
        lowerLabel.contains('giraffe')) {
      return Icons.park_rounded;
    }
    return Icons.emoji_symbols_rounded;
  }
}
