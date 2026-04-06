import 'package:flutter/material.dart';

import '../../data/models/bike_slot.dart';
import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/bike_slot_tile.dart';
import '../widgets/station_map_panel.dart';

class StationsScreen extends StatelessWidget {
  const StationsScreen({
    super.key,
    required this.viewModel,
    required this.onBookBike,
  });

  final RideAppViewModel viewModel;
  final ValueChanged<BikeSlot> onBookBike;

  @override
  Widget build(BuildContext context) {
    final station = viewModel.selectedStation;
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: StationMapPanel(
            stations: viewModel.stations,
            selectedStationId: station?.id,
            onSelect: viewModel.selectStation,
            accessLabel: viewModel.hasActivePass ? 'Pass active' : 'Buy ticket',
            fullScreen: true,
            showSelectedStationCard: false,
          ),
        ),
        if (station != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 720, maxHeight: 430),
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                    color: Colors.black.withValues(alpha: 0.12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 54,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5DDD6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE9DE),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Color(0xFFE46F2A),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      station.name,
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      station.address,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _StationBadge(
                                label: '${station.availableBikes} bikes ready',
                              ),
                              _StationBadge(
                                label: '${station.totalSlots} total slots',
                              ),
                              _StationBadge(label: viewModel.accessLabel),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Bikes and slots',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap any available bike slot to continue booking.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 14),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: station.slots.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.12,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemBuilder: (context, index) {
                              final slot = station.slots[index];
                              return BikeSlotTile(
                                slot: slot,
                                onTap: slot.isAvailable
                                    ? () => onBookBike(slot)
                                    : null,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _StationBadge extends StatelessWidget {
  const _StationBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2EC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF645C55),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
