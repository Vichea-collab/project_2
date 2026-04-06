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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(title: const Text('Purchase Ticket')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            Expanded(
              child: SectionCard(
                backgroundColor: const Color(0xFFD9D9D9),
                borderRadius: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buy Single Ride Ticket',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Cost:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '\$2.00',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Confirm your purchase.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isSubmitting ? null : _payTicket,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF4C84E8),
              ),
              child: const Text('Pay \$2.00'),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: _isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFA8CBF0),
              ),
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
