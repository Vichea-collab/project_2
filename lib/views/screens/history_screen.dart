import 'package:flutter/material.dart';

import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/section_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.viewModel});

  final RideAppViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activePass = viewModel.activePass;
    final currentBooking = viewModel.currentBooking;
    final bookingHistory = viewModel.bookingHistory;
    final latestBooking = bookingHistory.isEmpty ? null : bookingHistory.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      children: [
        SectionCard(
          backgroundColor: const Color(0xFFFFEEE3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recent activity', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text(
                'Review your latest bike bookings, pass updates, and account activity.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF8C5028),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _HistoryMetric(
                    value: '${viewModel.totalBookings}',
                    label: 'Bookings',
                  ),
                  _HistoryMetric(
                    value: activePass == null ? '0' : '1',
                    label: 'Active passes',
                  ),
                  _HistoryMetric(
                    value: '${viewModel.totalAvailableBikes}',
                    label: 'Nearby bikes',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (latestBooking != null) ...[
          Text('Latest booking', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineRow(
                  icon: Icons.bookmark_added_rounded,
                  title: 'Bike reserved',
                  subtitle:
                      '${latestBooking.stationName} • Slot ${latestBooking.slotLabel}',
                  trailing: _formatTime(latestBooking.bookedAt),
                ),
                const SizedBox(height: 16),
                Text(
                  currentBooking != null
                      ? 'Your active booking remains visible from the account tab until you complete the ride.'
                      : 'This booking is saved in your activity history.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ] else ...[
          SectionCard(
            backgroundColor: const Color(0xFFFFF4DA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No booking history yet',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'Once you reserve a bike, the latest booking will appear here.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF7D663E),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => viewModel.changeTab(1),
                  child: const Text('Browse stations'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
        Text('Activity timeline', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        if (activePass != null) ...[
          SectionCard(
            child: _TimelineRow(
              icon: Icons.confirmation_num_rounded,
              title: activePass.type.title,
              subtitle:
                  'Pass activated until ${_formatDate(activePass.expirationDate)}',
              trailing: _formatDate(activePass.purchasedAt),
            ),
          ),
          const SizedBox(height: 12),
        ],
        for (final booking in bookingHistory.take(5)) ...[
          SectionCard(
            child: _TimelineRow(
              icon: currentBooking?.bookedAt == booking.bookedAt
                  ? Icons.pedal_bike_rounded
                  : Icons.check_circle_outline_rounded,
              title: currentBooking?.bookedAt == booking.bookedAt
                  ? 'Active booking'
                  : 'Completed booking',
              subtitle:
                  'Station ${booking.stationName}, bike slot ${booking.slotLabel}',
              trailing: _formatDate(booking.bookedAt),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (bookingHistory.isEmpty && activePass == null)
          SectionCard(
            child: _TimelineRow(
              icon: Icons.history_rounded,
              title: 'No recent actions',
              subtitle:
                  'Purchase a pass or reserve a bike to build your history.',
              trailing: 'Today',
            ),
          ),
        const SizedBox(height: 18),
        Text('Quick links', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.map_rounded,
                title: 'Stations',
                subtitle: 'Reserve a bike',
                onTap: () => viewModel.changeTab(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.confirmation_num_rounded,
                title: 'Passes',
                subtitle: 'Manage access',
                onTap: () => viewModel.changeTab(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HistoryMetric extends StatelessWidget {
  const _HistoryMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              color: const Color(0xFFE46F2A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF8C5028)),
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEFE4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFFE46F2A)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          trailing,
          style: theme.textTheme.labelMedium?.copyWith(
            color: const Color(0xFF8B8179),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEFE4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFFE46F2A)),
            ),
            const SizedBox(height: 18),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

String _formatTime(DateTime date) {
  final hour = date.hour == 0
      ? 12
      : (date.hour > 12 ? date.hour - 12 : date.hour);
  final minute = date.minute.toString().padLeft(2, '0');
  final suffix = date.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}
