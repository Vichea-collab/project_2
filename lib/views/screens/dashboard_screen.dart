import 'package:flutter/material.dart';

import '../../data/models/bike_slot.dart';
import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/section_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.viewModel,
    required this.onBookBike,
  });

  final RideAppViewModel viewModel;
  final ValueChanged<BikeSlot> onBookBike;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightedStation = viewModel.highlightedStation;
    final featuredSlot = highlightedStation?.slots.cast<BikeSlot?>().firstWhere(
      (slot) => slot?.isAvailable == true,
      orElse: () => null,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE46F2A), Color(0xFFF08A4B)],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 14),
                color: const Color(0xFFE46F2A).withValues(alpha: 0.22),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Bike Rental Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Rent a bike in\njust a few taps.',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Manage your pass, discover stations, and book bikes from one clean interface.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _HeroStat(
                    value: '${viewModel.totalAvailableBikes}',
                    label: 'Bikes ready',
                  ),
                  _HeroStat(
                    value: '${viewModel.stationsWithBikes}',
                    label: 'Open stations',
                  ),
                  _HeroStat(
                    value: viewModel.hasActivePass ? 'Pass' : 'Ticket',
                    label: viewModel.accessLabel,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quick actions', style: theme.textTheme.titleLarge),
              const SizedBox(height: 14),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.22,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _QuickActionCard(
                    icon: Icons.map_rounded,
                    title: 'Open map',
                    subtitle: 'Browse stations and bike slots',
                    accentColor: const Color(0xFFE46F2A),
                    backgroundColor: const Color(0xFFFFF1E8),
                    onTap: () => viewModel.changeTab(1),
                  ),
                  _QuickActionCard(
                    icon: Icons.confirmation_num_rounded,
                    title: 'Manage pass',
                    subtitle: 'Select or replace a ride pass',
                    accentColor: const Color(0xFFCC5C22),
                    backgroundColor: const Color(0xFFFFEEE3),
                    onTap: () => viewModel.changeTab(2),
                  ),
                  _QuickActionCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'My account',
                    subtitle: 'Check booking and rider profile',
                    accentColor: const Color(0xFF9D4B22),
                    backgroundColor: const Color(0xFFFFF4EC),
                    onTap: () => viewModel.changeTab(3),
                  ),
                  _QuickActionCard(
                    icon: Icons.pedal_bike_rounded,
                    title: 'Reserve now',
                    subtitle: featuredSlot == null
                        ? 'No bike currently available'
                        : 'Book a bike from ${highlightedStation?.name}',
                    accentColor: const Color(0xFFE46F2A),
                    backgroundColor: const Color(0xFFFFF1E8),
                    onTap: featuredSlot == null
                        ? null
                        : () => onBookBike(featuredSlot),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (viewModel.hasCurrentBooking)
          SectionCard(
            backgroundColor: const Color(0xFF2F2A27),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.bookmark_added_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${viewModel.currentBooking!.stationName} • Slot ${viewModel.currentBooking!.slotLabel}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => viewModel.changeTab(3),
                  icon: const Icon(Icons.chevron_right_rounded),
                  color: Colors.white,
                ),
              ],
            ),
          )
        else
          SectionCard(
            backgroundColor: const Color(0xFFFFF4DA),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD18A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFAB6A00),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No bike reserved yet',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Open the stations tab to choose an available bike.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF7D663E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 18),
        Text('Featured stations', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        for (final station in viewModel.stations.take(3)) ...[
          SectionCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8DA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFFE46F2A),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(station.name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(station.address, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _PillLabel(
                            label: '${station.availableBikes} bikes ready',
                          ),
                          _PillLabel(
                            label: '${station.totalSlots} total slots',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    viewModel.selectStation(station.id);
                    viewModel.changeTab(1);
                  },
                  child: const Text('Open'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.backgroundColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  const _PillLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2EC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF625B55),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
