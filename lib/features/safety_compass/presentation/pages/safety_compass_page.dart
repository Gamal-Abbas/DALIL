import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil/core/di/injection_container.dart' as di;
import 'package:dalil/features/safety_compass/presentation/cubit/safety_compass_cubit.dart';
import 'package:dalil/features/safety_compass/presentation/cubit/safety_compass_state.dart';
import 'package:dalil/features/safety_compass/presentation/widgets/location_card.dart';
import 'package:dalil/features/safety_compass/presentation/widgets/emergency_sos_button.dart';

class SafetyCompassPage extends StatelessWidget {
  const SafetyCompassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SafetyCompassCubit>()..initialize(),
      child: const _SafetyCenterView(),
    );
  }
}

class _SafetyCenterView extends StatelessWidget {
  const _SafetyCenterView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Center'),
      ),
      body: BlocBuilder<SafetyCompassCubit, SafetyCompassState>(
        builder: (context, state) {
          return switch (state) {
            Initial() || Loading() => const Center(
                child: CircularProgressIndicator(),
              ),
            SafetyCompassError(:final message) => _buildErrorState(
                context,
                theme,
                message,
              ),
            LocationLoaded(:final locationData) => _buildContent(
                context,
                locationData: locationData,
              ),
            CompassUpdated(:final locationData) => _buildContent(
                context,
                locationData: locationData,
              ),
          };
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required dynamic locationData,
  }) {
    if (locationData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LocationCard(
            locationData: locationData,
            onRefresh: () => context
                .read<SafetyCompassCubit>()
                .refreshLocation(),
          ),
          const SizedBox(height: 32),
          const EmergencySosButton(),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    ThemeData theme,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  context.read<SafetyCompassCubit>().initialize(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
