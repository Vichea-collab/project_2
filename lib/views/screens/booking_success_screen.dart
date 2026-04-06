import 'package:flutter/material.dart';

import '../../data/models/bike_slot.dart';
import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/section_card.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({
    super.key,
    required this.viewModel,
    required this.slot,
  });

  final RideAppViewModel viewModel;
  final BikeSlot slot;

  @override
  Widget build(BuildContext context) {
    final station = viewModel.selectedStation;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(title: const Text('Booking Successful')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SectionCard(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEEE3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 46,
                    color: Color(0xFFE46F2A),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Booking successful',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 26),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your bike has been reserved and is ready for pickup.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F4EF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _DetailRow(label: 'Bike', value: '#${slot.label}'),
                      const SizedBox(height: 12),
                      _DetailRow(label: 'Station', value: station?.name ?? '-'),
                      const SizedBox(height: 12),
                      _DetailRow(label: 'Slot', value: slot.label),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('View booking'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Back to station'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

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
