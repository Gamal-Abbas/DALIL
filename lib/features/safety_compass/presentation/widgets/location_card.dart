import 'package:flutter/material.dart';
import 'package:dalil/features/safety_compass/domain/entities/location_data.dart';

class LocationCard extends StatelessWidget {
  final LocationData locationData;
  final VoidCallback onRefresh;

  const LocationCard({
    super.key,
    required this.locationData,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Your GPS coordinates',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh location',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDataRow(
              context,
              label: 'Latitude',
              value: locationData.latitude.toStringAsFixed(6),
            ),
            const SizedBox(height: 10),
            _buildDataRow(
              context,
              label: 'Longitude',
              value: locationData.longitude.toStringAsFixed(6),
            ),
            const SizedBox(height: 10),
            _buildDataRow(
              context,
              label: 'Accuracy',
              value: '${locationData.accuracy.toStringAsFixed(1)} m',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
