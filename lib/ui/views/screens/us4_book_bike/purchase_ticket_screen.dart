import 'package:flutter/material.dart';

import 'view_model/booking_view_model.dart';
import 'widgets/purchase_ticket_content.dart';

class PurchaseTicketScreen extends StatelessWidget {
  const PurchaseTicketScreen({super.key, required this.viewModel});

  final BookingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F4EF),
          appBar: AppBar(title: const Text('Purchase Ticket')),
          body: PurchaseTicketContent(
            viewModel: viewModel,
            onPay: () => _payTicket(context),
            onCancel: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }

  Future<void> _payTicket(BuildContext context) async {
    final purchased = await viewModel.purchaseSingleTicket();

    if (!context.mounted) {
      return;
    }

    if (!purchased) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.actionError ?? 'Unable to purchase the ticket.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }
}
