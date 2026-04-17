import 'package:flutter/material.dart';

import '../../../models/bike_slot.dart';
import '../../viewmodels/ride_app_view_model.dart';
import 'us1_select_pass/pass_selection_screen.dart';
import 'us2_view_stations/stations_screen.dart';
import 'us4_book_bike/booking_screen.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key, required this.viewModel});

  final RideAppViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (viewModel.errorMessage != null && viewModel.stations.isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  viewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: viewModel.initialize,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final header = _headerForTab(viewModel.currentTabIndex, viewModel);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFBF6), Color(0xFFF6F2EC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            header.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            header.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.person_outline_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: viewModel.currentTabIndex,
                  children: [
                    StationsScreen(
                      viewModel: viewModel,
                      onBookBike: (slot) => _openBooking(context, slot),
                    ),
                    PassSelectionScreen(viewModel: viewModel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: viewModel.currentTabIndex,
        onDestinationSelected: viewModel.changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Stations',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_num_outlined),
            selectedIcon: Icon(Icons.confirmation_num_rounded),
            label: 'Passes',
          ),
        ],
      ),
    );
  }

  Future<void> _openBooking(BuildContext context, BikeSlot slot) async {
    final booked = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BookingScreen(viewModel: viewModel, slot: slot),
      ),
    );

    if (booked == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bike booked at ${viewModel.selectedStation?.name}.'),
        ),
      );
    }
  }
}

_HeaderContent _headerForTab(int index, RideAppViewModel viewModel) {
  switch (index) {
    case 0:
      return _HeaderContent(
        title: 'Stations',
        subtitle: '${viewModel.totalAvailableBikes} bikes available nearby',
      );
    case 1:
      return _HeaderContent(title: 'Passes', subtitle: viewModel.accessLabel);
    default:
      return const _HeaderContent(
        title: 'RideFlow',
        subtitle: 'Bike rental mobile app',
      );
  }
}

class _HeaderContent {
  const _HeaderContent({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
