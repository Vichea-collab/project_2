import 'package:flutter/material.dart';

import '../../../widgets/section_card.dart';
import 'booking_flow_shared.dart';
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
          const BookingFlowStepHeader(
            step: 'Step 2',
            title: 'Single ticket',
            description: 'Pay for one ride to unlock this reservation.',
          ),
          const SizedBox(height: 18),
          Expanded(
            child: SectionCard(
              backgroundColor: const Color(0xFFFCFAF7),
              borderRadius: 24,
              borderSide: const BorderSide(color: Color(0xFFE8DED4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment summary',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This ticket covers one reservation for ${viewModel.stationName}, slot ${viewModel.slotLabel}.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF655E58),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE8DED4)),
                    ),
                    child: Column(
                      children: [
                        const BookingFlowDetailRow(
                          label: 'Ride access',
                          value: 'Single ticket',
                        ),
                        const SizedBox(height: 12),
                        BookingFlowDetailRow(
                          label: 'Station',
                          value: viewModel.stationName,
                        ),
                        const SizedBox(height: 12),
                        BookingFlowDetailRow(
                          label: 'Slot',
                          value: viewModel.slotLabel,
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        const BookingFlowDetailRow(
                          label: 'Total',
                          value: '\$2.00',
                          emphasize: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F4F0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6E8DC),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            color: Color(0xFFC56B2A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'After payment, the app will finish the reservation and move you to the success screen.',
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
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
