import 'package:flutter/material.dart';

import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/section_card.dart';

class PurchaseTicketScreen extends StatefulWidget {
  const PurchaseTicketScreen({super.key, required this.viewModel});

  final RideAppViewModel viewModel;

  @override
  State<PurchaseTicketScreen> createState() => _PurchaseTicketScreenState();
}

class _PurchaseTicketScreenState extends State<PurchaseTicketScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(title: const Text('Purchase Ticket')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          children: [
            Expanded(
              child: SectionCard(
                backgroundColor: const Color(0xFFFFFCFA),
                borderRadius: 20,
                borderSide: const BorderSide(color: Color(0xFFE7D7CA)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buy Single Ride Ticket',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(
                          'Cost:',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Text(
                          '\$2.00',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Confirm your purchase to unlock this booking.',
                      style: theme.textTheme.bodyLarge,
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
                            width: 40,
                            height: 40,
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
                              'Single ride ticket is valid for the current booking flow.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _isSubmitting ? null : _payTicket,
              child: const Text('Pay \$2.00'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _payTicket() async {
    setState(() => _isSubmitting = true);
    await widget.viewModel.purchaseSingleTicket();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }
}
