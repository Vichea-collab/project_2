import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Text(
          'Reserve your bike in three steps: review, unlock access, confirm.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        SectionCard(
          backgroundColor: const Color(0xFFFFFCFA),
          borderSide: const BorderSide(color: Color(0xFFE8D8CB)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StepBadge(label: 'Step 1 · Review bike'),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8DA),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.pedal_bike_rounded,
                      color: Color(0xFFD85B18),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.bikeLabel,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bike is available and ready to reserve.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF7F4A25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
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
          backgroundColor: const Color(0xFFFFF4DA),
          borderSide: const BorderSide(color: Color(0xFFF0DFAB)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StepBadge(label: 'Step 2 · Access'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: viewModel.canConfirm
                          ? const Color(0xFFFFE0CC)
                          : const Color(0xFFFFD18A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      viewModel.canConfirm
                          ? Icons.verified_rounded
                          : Icons.info_outline_rounded,
                      color: viewModel.canConfirm
                          ? const Color(0xFFE46F2A)
                          : const Color(0xFFAB6A00),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.accessTitle,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          viewModel.accessDescription,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF7D663E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!viewModel.canConfirm) ...[
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: viewModel.isBusy ? null : onBuyTicket,
                  child: const Text('Buy single ticket'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: viewModel.isBusy ? null : onBuyPass,
                  child: const Text('Go to pass selection'),
                ),
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
        const SizedBox(height: 22),
        SectionCard(
          backgroundColor: const Color(0xFF2F2A27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StepBadge(
                label: 'Step 3 · Confirm',
                backgroundColor: Color(0x26FFFFFF),
                textColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                'Finish the reservation to hold this bike at ${viewModel.stationName}.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: viewModel.canConfirm && !viewModel.isBusy
                    ? onConfirm
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE46F2A),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  viewModel.isConfirming ? 'Confirming...' : 'Confirm booking',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({
    required this.label,
    this.backgroundColor = const Color(0xFFFFF1E7),
    this.textColor = const Color(0xFF8A4B24),
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
      ),
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
        color: const Color(0xFFF8F3EE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6D8CC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF756C66),
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
