import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageSourceSelector extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImageSourceSelector({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose Image Source',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select an image to decode hieroglyphic symbols',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SourceCard(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  subtitle: 'Take a photo',
                  onTap: onCameraTap,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SourceCard(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  subtitle: 'Pick from gallery',
                  onTap: onGalleryTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
