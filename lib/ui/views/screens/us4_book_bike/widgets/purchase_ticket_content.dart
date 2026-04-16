import 'package:flutter/material.dart';

import '../../../widgets/section_card.dart';
import '../view_model/booking_view_model.dart';

class PurchaseTicketContent extends StatelessWidget {
  const PurchaseTicketContent({
    super.key,
    required this.viewModel,
    required this.onPay,
    required this.onCancel,
  });

  final BookingViewModel viewModel;
  final VoidCallback onPay;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        children: [
          Expanded(
            child: SectionCard(
              backgroundColor: const Color(0xFFFFFCFA),
              borderRadius: 24,
              borderSide: const BorderSide(color: Color(0xFFE7D7CA)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeaderBadge(label: 'Single ride purchase'),
                  const SizedBox(height: 16),
                  Text(
                    'Purchase ticket for ${viewModel.bikeLabel}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This ticket unlocks the reservation for ${viewModel.stationName}, slot ${viewModel.slotLabel}.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  const Divider(height: 1),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$2.00',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F3EE),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE7D7CA)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE8DA),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            color: Color(0xFFE46F2A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Single ride ticket is valid for this booking flow only.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF5F5751),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.actionError != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      viewModel.actionError!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFD05C2A),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: viewModel.isBusy ? null : onPay,
            child: Text(
              viewModel.isPurchasingTicket ? 'Processing...' : 'Pay \$2.00',
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: viewModel.isBusy ? null : onCancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF8A4B24),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
