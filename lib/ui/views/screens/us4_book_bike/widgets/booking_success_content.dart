import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/section_card.dart';
import 'booking_flow_shared.dart';
import '../view_model/booking_view_model.dart';

class BookingSuccessContent extends StatelessWidget {
  const BookingSuccessContent({
    super.key,
    required this.viewModel,
    required this.onOpenHistory,
    required this.onOpenStations,
  });

  final BookingViewModel viewModel;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenStations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SectionCard(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          backgroundColor: const Color(0xFFFCFAF7),
          borderSide: const BorderSide(color: Color(0xFFE8DED4)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF4EC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 46,
                    color: Color(0xFF2F6A46),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Reservation complete',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(fontSize: 28),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Your bike is now reserved and ready for pickup.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF655E58),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8DED4)),
                ),
                child: Column(
                  children: [
                    BookingFlowDetailRow(
                      label: 'Station',
                      value: viewModel.stationName,
                    ),
                    const SizedBox(height: 12),
                    BookingFlowDetailRow(
                      label: 'Slot',
                      value: viewModel.slotLabel,
                    ),
                    const SizedBox(height: 12),
                    const BookingFlowDetailRow(
                      label: 'Status',
                      value: 'Ready for pickup',
                      valueColor: Color(0xFF2F6A46),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                onPressed: onOpenHistory,
                text: 'View history',
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                onPressed: onOpenStations,
                text: 'Go to stations',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
