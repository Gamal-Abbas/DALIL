import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyBottomSheet extends StatelessWidget {
  const EmergencyBottomSheet({super.key});

  static const _services = [
    _EmergencyService(
      icon: Icons.local_police_outlined,
      label: 'Police',
      number: '122',
    ),
    _EmergencyService(
      icon: Icons.medical_services_outlined,
      label: 'Ambulance',
      number: '123',
    ),
    _EmergencyService(
      icon: Icons.fire_truck_outlined,
      label: 'Fire',
      number: '180',
    ),
    _EmergencyService(
      icon: Icons.person_outlined,
      label: 'Tourist Police',
      number: '126',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Text(
              'Emergency Services',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap a service to call directly',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            ..._services.map(
              (service) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _EmergencyServiceCard(service: service),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyServiceCard extends StatelessWidget {
  final _EmergencyService service;

  const _EmergencyServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _dial(service.number),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  service.icon,
                  color: theme.colorScheme.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  service.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone,
                      color: theme.colorScheme.error,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      service.number,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dial(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _EmergencyService {
  final IconData icon;
  final String label;
  final String number;

  const _EmergencyService({
    required this.icon,
    required this.label,
    required this.number,
  });
}
