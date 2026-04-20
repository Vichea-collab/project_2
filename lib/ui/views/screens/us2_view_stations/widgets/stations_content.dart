import 'package:flutter/material.dart';

import '../../../../../models/bike_station.dart';
import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_button.dart';
import '../view_model/stations_view_model.dart';
import 'station_map_panel.dart';

class StationsContent extends StatelessWidget {
  const StationsContent({
    super.key,
    required this.viewModel,
    required this.onOpenBikes,
  });

  final StationsViewModel viewModel;
  final ValueChanged<BikeStation> onOpenBikes;

  @override
  Widget build(BuildContext context) {
    final station = viewModel.selectedStation;
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: StationMapPanel(
            stations: viewModel.filteredStations,
            selectedStationId: station?.id,
            onSelect: viewModel.selectStation,
            accessLabel: viewModel.hasActivePass ? 'Pass active' : 'Buy ticket',
            searchController: viewModel.searchController,
            onSearchChanged: viewModel.updateSearchQuery,
            onClearSearch: viewModel.clearSearch,
            fullScreen: true,
            showSelectedStationCard: false,
          ),
        ),
        if (viewModel.hasSearchQuery &&
            viewModel.filteredStations.isEmpty &&
            station == null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                    color: Colors.black.withValues(alpha: 0.10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    color: Color(0xFFE46F2A),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No stations match "${viewModel.searchQuery}".',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (station != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 720, maxHeight: 300),
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
                    child: Padding(
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
                              const SizedBox(width: 8),
                              Material(
                                color: const Color(0xFFF7F2EC),
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: viewModel.clearSelectedStation,
                                  child: const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Color(0xFF6F6660),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              CustomBadge(
                                text: '${station.availableBikes} bikes ready',
                              ),
                              CustomBadge(
                                text: '${station.totalSlots} total slots',
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Open the bike list to choose a slot and continue booking.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 14),
                          PrimaryButton(
                            onPressed: () => onOpenBikes(station),
                            text: 'View bikes',
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

