import 'package:flutter/material.dart';

import '../../data/models/bike_slot.dart';
import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/section_card.dart';
import 'account_screen.dart';
import 'booking_screen.dart';
import 'history_screen.dart';
import 'pass_selection_screen.dart';
import 'stations_screen.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key, required this.viewModel});

  final RideAppViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (viewModel.errorMessage != null) {
      return Scaffold(body: Center(child: Text(viewModel.errorMessage!)));
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
                    HistoryScreen(viewModel: viewModel),
                    StationsScreen(
                      viewModel: viewModel,
                      onBookBike: (slot) => _openBooking(context, slot),
                    ),
                    PassSelectionScreen(viewModel: viewModel),
                    AccountScreen(viewModel: viewModel),
                  ],
                ),
              ),
              if (viewModel.currentBooking != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: InkWell(
                    onTap: () => viewModel.changeTab(0),
                    borderRadius: BorderRadius.circular(24),
                    child: SectionCard(
                      backgroundColor: const Color(0xFF2F2A27),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text(
                          'Current booking',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          '${viewModel.currentBooking!.stationName} • Slot ${viewModel.currentBooking!.slotLabel}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
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
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Account',
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
          content: Text(
            'Bike ${slot.label} booked at ${viewModel.selectedStation?.name}.',
          ),
        ),
      );
    }
  }
}

_HeaderContent _headerForTab(int index, RideAppViewModel viewModel) {
  switch (index) {
    case 0:
      return const _HeaderContent(
        title: 'History',
        subtitle: 'Recent bookings and pass activity',
      );
    case 1:
      return _HeaderContent(
        title: 'Stations',
        subtitle: '${viewModel.totalAvailableBikes} bikes available nearby',
      );
    case 2:
      return _HeaderContent(title: 'Passes', subtitle: viewModel.accessLabel);
    case 3:
      return const _HeaderContent(
        title: 'Account',
        subtitle: 'Bookings, access, and rider settings',
      );
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
