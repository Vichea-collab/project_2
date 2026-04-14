import 'package:flutter/material.dart';

import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/section_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.viewModel});

  final RideAppViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentBooking = viewModel.currentBooking;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      children: [
        Text('Current booking', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          currentBooking == null
              ? 'No active bike booking right now.'
              : 'Your active booking is shown below. Complete the ride when you are done.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 18),
        if (currentBooking != null)
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: 'Station', value: currentBooking.stationName),
                const SizedBox(height: 12),
                _InfoRow(label: 'Slot', value: currentBooking.slotLabel),
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Reserved at',
                  value: _formatTime(currentBooking.bookedAt),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    viewModel.completeCurrentBooking();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ride marked as completed.'),
                      ),
                    );
                  },
                  child: const Text('Complete ride'),
                ),
              ],
            ),
          )
        else
          SectionCard(
            backgroundColor: const Color(0xFFFFF4DA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No current booking', style: theme.textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(
                  'Go to the stations tab to reserve a bike.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF7D663E),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => viewModel.changeTab(1),
                  child: const Text('Go to stations'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

String _formatTime(DateTime date) {
  final hour = date.hour == 0
      ? 12
      : (date.hour > 12 ? date.hour - 12 : date.hour);
  final minute = date.minute.toString().padLeft(2, '0');
  final suffix = date.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}
