import 'package:flutter/material.dart';

import '../../data/models/bike_slot.dart';
import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/section_card.dart';
import 'booking_success_screen.dart';
import 'pass_selection_screen.dart';
import 'purchase_ticket_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.viewModel, required this.slot});

  final RideAppViewModel viewModel;
  final BikeSlot slot;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final station = widget.viewModel.selectedStation;
    final hasActivePass = widget.viewModel.hasActivePass;
    final hasSingleTicket = widget.viewModel.hasSingleTicket;
    final canConfirm = hasActivePass || hasSingleTicket;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(title: const Text('Book a Bike')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE9DE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.pedal_bike_rounded,
                        color: Color(0xFFE46F2A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bike #${widget.slot.label}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _InfoLine(label: 'Station', value: station?.name ?? '-'),
                const SizedBox(height: 10),
                _InfoLine(label: 'Slot', value: widget.slot.label),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF54B435),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Status: Available',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!canConfirm) ...[
            _WarningAccessCard(
              onBuyTicket: _isSubmitting ? null : _openTicketPurchase,
              onBuyPass: _isSubmitting ? null : _openPassSelection,
            ),
          ] else if (hasSingleTicket) ...[
            _ReadyAccessCard(
              title: 'Single Ride Ticket',
              subtitle:
                  'Ticket purchased successfully. You can confirm this booking now.',
              chipLabel: 'Ticket ready',
            ),
          ] else if (hasActivePass) ...[
            _ReadyAccessCard(
              title: widget.viewModel.activePass!.type.title,
              subtitle:
                  'Active pass available until ${_formatDate(widget.viewModel.activePass!.expirationDate)}.',
              chipLabel: 'Active pass',
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: canConfirm && !_isSubmitting ? _confirmBooking : null,
            child: Text(
              canConfirm ? 'Confirm Booking' : 'Complete access first',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openTicketPurchase() async {
    final purchased = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PurchaseTicketScreen(viewModel: widget.viewModel),
      ),
    );

    if (!mounted) {
      return;
    }

    if (purchased == true) {
      setState(() {});
    }
  }

  Future<void> _openPassSelection() async {
    final navigator = Navigator.of(context);

    await navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Select a pass')),
          body: PassSelectionScreen(
            viewModel: widget.viewModel,
            selectionMode: true,
          ),
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _confirmBooking() async {
    setState(() => _isSubmitting = true);
    final success = await widget.viewModel.confirmBooking(widget.slot);
    if (!mounted) {
      return;
    }

    setState(() => _isSubmitting = false);
    if (success) {
      await Navigator.of(context).pushReplacement<bool, bool>(
        MaterialPageRoute<bool>(
          builder: (_) => BookingSuccessScreen(
            viewModel: widget.viewModel,
            slot: widget.slot,
          ),
        ),
      );
    }
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: const Color(0xFF3D6BB0)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF3D6BB0),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _WarningAccessCard extends StatelessWidget {
  const _WarningAccessCard({
    required this.onBuyTicket,
    required this.onBuyPass,
  });

  final VoidCallback? onBuyTicket;
  final VoidCallback? onBuyPass;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3E6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                top: BorderSide(color: Color(0xFFFFA21A), width: 4),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_rounded, color: Color(0xFFFF9B00)),
                SizedBox(width: 10),
                Text(
                  'No Active Pass',
                  style: TextStyle(
                    color: Color(0xFF6B6158),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              'You need a pass or ticket to continue.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B6158),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: onBuyTicket,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF9B00),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Buy Ticket'),
                  SizedBox(width: 10),
                  Icon(Icons.chevron_right_rounded, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: onBuyPass,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1668D8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Buy Pass'),
                  SizedBox(width: 10),
                  Icon(Icons.chevron_right_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadyAccessCard extends StatelessWidget {
  const _ReadyAccessCard({
    required this.title,
    required this.subtitle,
    required this.chipLabel,
  });

  final String title;
  final String subtitle;
  final String chipLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF4FB41A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                const Icon(Icons.pedal_bike_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  chipLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
