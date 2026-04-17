import 'package:flutter/material.dart';

import '../../../../models/bike_slot.dart';
import '../../../viewmodels/ride_app_view_model.dart';
import '../us1_select_pass/pass_selection_screen.dart';
import 'booking_success_screen.dart';
import 'purchase_ticket_screen.dart';
import 'view_model/booking_view_model.dart';
import 'widgets/booking_content.dart';
import 'widgets/booking_flow_shared.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.viewModel, required this.slot});

  final RideAppViewModel viewModel;
  final BikeSlot slot;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late final BookingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BookingViewModel(
      appViewModel: widget.viewModel,
      slot: widget.slot,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('Step 1 of 3')),
          body: BookingFlowBackground(
            child: BookingContent(
              viewModel: _viewModel,
              onBuyTicket: _openTicketPurchase,
              onBuyPass: _openPassSelection,
              onConfirm: _confirmBooking,
            ),
          ),
        );
      },
    );
  }

  Future<void> _openTicketPurchase() async {
    _viewModel.clearActionError();

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PurchaseTicketScreen(viewModel: _viewModel),
      ),
    );

    if (!mounted || result != true) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  Future<void> _openPassSelection() async {
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('Step 2 of 3')),
          body: BookingFlowBackground(
            child: PassSelectionScreen(
              viewModel: widget.viewModel,
              selectionMode: true,
            ),
          ),
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    await _confirmBooking();
  }

  Future<void> _confirmBooking() async {
    final success = await _viewModel.confirmBooking();

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.actionError ?? 'Unable to confirm the booking.',
          ),
        ),
      );
      return;
    }

    await Navigator.of(context).pushReplacement<bool, bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BookingSuccessScreen(viewModel: _viewModel),
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }
}
