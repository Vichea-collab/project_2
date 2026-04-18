import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/ride_app_view_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RideAppViewModel>();
    final theme = Theme.of(context);
    final history = viewModel.state.bookingHistory;

    if (history.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEE3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: Color(0xFFE46F2A),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'No booking history yet',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your completed bike reservations will appear here after you book one.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: history.length + 1,
      separatorBuilder: (_, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2F2A27),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.state.currentUser?.name ?? 'Guest Rider',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${history.length} bookings',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keep track of your recent rides and pickup locations.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.74),
                  ),
                ),
              ],
            ),
          );
        }

        final booking = history[index - 1];
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEE3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.pedal_bike_rounded,
                  color: Color(0xFFE46F2A),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.stationName,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Slot ${booking.slotLabel}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formatBookingDate(booking.bookedAt),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF7B746E),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String formatBookingDate(DateTime date) {
  const months = [
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

  return '${months[date.month - 1]} ${date.day}';
}
