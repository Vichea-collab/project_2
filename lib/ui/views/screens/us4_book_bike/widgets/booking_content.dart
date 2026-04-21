import 'package:flutter/material.dart';

import '../../../widgets/custom_badge.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/section_card.dart';
import '../view_model/booking_view_model.dart';

class BookingContent extends StatelessWidget {
  const BookingContent({
    super.key,
    required this.viewModel,
    required this.onBuyTicket,
    required this.onBuyPass,
    required this.onConfirm,
  });

  final BookingViewModel viewModel;
  final VoidCallback onBuyTicket;
  final VoidCallback onBuyPass;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        SectionCard(
          backgroundColor: const Color(0xFFFCFAF7),
          borderSide: const BorderSide(color: Color(0xFFE8DED4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Bike',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Check the pickup details.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF655E58),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE8DED4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6E8DC),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.pedal_bike_rounded,
                        color: Color(0xFFC56B2A),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected bike',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ready for pickup',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF746C65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _InfoPill(
                      label: 'Station',
                      value: viewModel.stationName,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoPill(label: 'Slot', value: viewModel.slotLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionCard(
          backgroundColor: Colors.white,
          borderSide: const BorderSide(color: Color(0xFFE8DED4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.accessTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          viewModel.accessDescription,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF655E58),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomBadge(
                    text: viewModel.canConfirm ? 'Ready' : 'Choose one',
                    backgroundColor: viewModel.canConfirm
                        ? const Color(0xFFEAF4EC)
                        : const Color(0xFFF8EFE6),
                    textColor: viewModel.canConfirm
                        ? const Color(0xFF2F6A46)
                        : const Color(0xFF935A2B),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F4F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: viewModel.canConfirm
                            ? const Color(0xFFEAF4EC)
                            : const Color(0xFFF6E8DC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        viewModel.canConfirm
                            ? Icons.verified_rounded
                            : Icons.lock_open_rounded,
                        color: viewModel.canConfirm
                            ? const Color(0xFF2F6A46)
                            : theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        viewModel.canConfirm
                            ? 'Access is active.'
                            : 'Pay for this ride or choose a pass to continue.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF5D5650),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (!viewModel.canConfirm) ...[
                PrimaryButton(
                  onPressed: onBuyTicket,
                  text: 'Pay \$2.00 for this ride',
                  isLoading: viewModel.isBusy,
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  onPressed: onBuyPass,
                  text: 'Choose a pass',
                  isLoading: viewModel.isBusy,
                ),
              ] else ...[
                PrimaryButton(
                  onPressed: onConfirm,
                  text: 'Finish reservation',
                  isLoading: viewModel.isBusy,
                ),
                if (viewModel.hasActivePass) ...[
                  const SizedBox(height: 10),
                  SecondaryButton(
                    onPressed: onBuyPass,
                    text: 'Change pass',
                    isLoading: viewModel.isBusy,
                  ),
                ],
              ],
            ],
          ),
        ),
        if (viewModel.actionError != null) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEFEA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF2C1B1)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFD05C2A),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    viewModel.actionError!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFA34820),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8DED4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF7A726B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
