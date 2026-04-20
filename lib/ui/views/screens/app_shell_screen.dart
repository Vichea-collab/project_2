import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/bike_slot.dart';
import '../../../models/bike_station.dart';
import '../../state/ride_app_state.dart';
import '../../viewmodels/ride_app_view_model.dart';
import 'us1_select_pass/pass_selection_screen.dart';
import 'us2_view_stations/stations_screen.dart';
import 'us3_view_bikes/bikes_screen.dart';
import 'us4_book_bike/booking_screen.dart';
import 'us5_history/history_screen.dart';
import '../widgets/custom_button.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RideAppViewModel>();
    final appState = viewModel.state;

    if (appState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (appState.errorMessage != null && appState.stations.isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appState.errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  onPressed: viewModel.initialize,
                  text: 'Retry',
                ),
              ],
            ),
          ),
        ),
      );
    }

    final header = buildAppShellHeader(appState.currentTabIndex, appState);

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
                  index: appState.currentTabIndex,
                  children: [
                    StationsScreen(
                      onOpenBikes: (station) => _openBikes(context, station),
                    ),
                    const PassSelectionScreen(),
                    const HistoryScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: appState.currentTabIndex,
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
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Future<void> _openBooking(BuildContext context, BikeSlot slot) async {
    final booked = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => BookingScreen(slot: slot)),
    );

    if (booked == true && context.mounted) {
      final viewModel = context.read<RideAppViewModel>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bike booked at ${viewModel.state.selectedStation?.name}.',
          ),
        ),
      );
    }
  }

  Future<void> _openBikes(BuildContext context, BikeStation station) async {
    final viewModel = context.read<RideAppViewModel>();
    viewModel.selectStation(station.id);
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            BikesScreen(onBookBike: (slot) => _openBooking(context, slot)),
      ),
    );
  }
}

AppShellHeader buildAppShellHeader(int index, RideAppState appState) {
  switch (index) {
    case 0:
      return AppShellHeader(
        title: 'Stations',
        subtitle: '${appState.totalAvailableBikes} bikes available nearby',
      );
    case 1:
      return AppShellHeader(title: 'Passes', subtitle: appState.accessLabel);
    case 2:
      return AppShellHeader(
        title: 'History',
        subtitle: '${appState.bookingHistory.length} bookings saved',
      );
    default:
      return const AppShellHeader(
        title: 'RideFlow',
        subtitle: 'Bike rental mobile app',
      );
  }
}

class AppShellHeader {
  const AppShellHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
