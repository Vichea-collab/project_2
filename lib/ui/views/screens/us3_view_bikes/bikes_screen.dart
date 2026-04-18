import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/bike_slot.dart';
import '../../../viewmodels/ride_app_view_model.dart';
import 'widgets/bike_slot_tile.dart';

class BikesScreen extends StatelessWidget {
  const BikesScreen({super.key, required this.onBookBike});

  final ValueChanged<BikeSlot> onBookBike;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RideAppViewModel>();
    final appState = viewModel.state;
    final station = appState.selectedStation;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Station info')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F4EE), Color(0xFFF1ECE5)],
          ),
        ),
        child: station == null
            ? Center(
                child: Text(
                  'No station selected.',
                  style: theme.textTheme.bodyLarge,
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name.toUpperCase(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            letterSpacing: 0.8,
                            color: const Color(0xFF8A5C3D),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          station.address,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _MetaBadge(
                              icon: Icons.pedal_bike_rounded,
                              value: '${station.availableBikes}',
                              label: 'ready',
                              accent: const Color(0xFFE46F2A),
                            ),
                            _MetaBadge(
                              icon: Icons.inventory_2_outlined,
                              value: '${station.totalSlots}',
                              label: 'slots',
                              accent: const Color(0xFF8A817B),
                            ),
                            _MetaBadge(
                              icon: Icons.confirmation_num_outlined,
                              value: appState.hasActivePass ? 'Pass' : 'Ticket',
                              label: 'access',
                              accent: const Color(0xFF2F6A46),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Available bikes',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose one bike to continue the booking flow.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  for (final slot in station.slots) ...[
                    BikeSlotTile(
                      slot: slot,
                      onTap: slot.isAvailable ? () => onBookBike(slot) : null,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
