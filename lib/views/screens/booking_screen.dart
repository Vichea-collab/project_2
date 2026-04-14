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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8DA),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.pedal_bike_rounded,
                        color: Color(0xFFE46F2A),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bike #${widget.slot.label}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontSize: 26,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            station?.name ?? 'Unknown station',
                            style: theme.textTheme.bodyLarge,
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
                        value: station?.name ?? '-',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InfoPill(label: 'Slot', value: widget.slot.label),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7EE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF39A96B),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Bike is available and ready to reserve.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF2B6B4F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (hasActivePass)
            _AccessReadyCard(
              title: 'Active Pass',
              subtitle:
                  '${widget.viewModel.activePass!.type.title} active until ${_formatDate(widget.viewModel.activePass!.expirationDate)}.',
              helperText:
                  'You already have ride access. Confirm the booking when ready.',
              icon: Icons.confirmation_num_rounded,
            )
          else if (hasSingleTicket)
            const _AccessReadyCard(
              title: 'Single ticket ready',
              subtitle: '\$2.00 ticket purchased for this booking.',
              helperText:
                  'Your payment is complete. Confirm the booking to reserve the bike.',
              icon: Icons.receipt_long_rounded,
            )
          else
            _AccessChoiceCard(
              onBuyTicket: _isSubmitting ? null : _openTicketPurchase,
              onBuyPass: _isSubmitting ? null : _openPassSelection,
            ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: canConfirm && !_isSubmitting ? _confirmBooking : null,
            child: Text(canConfirm ? 'Confirm booking' : 'Choose access first'),
          ),
        ],
      ),
    );
  }

  Future<void> _openTicketPurchase() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PurchaseTicketScreen(viewModel: widget.viewModel),
      ),
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Single ticket purchased.')));
    }
  }

  Future<void> _openPassSelection() async {
    await Navigator.of(context).push(
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
        color: const Color(0xFFF7F4EF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _AccessChoiceCard extends StatelessWidget {
  const _AccessChoiceCard({required this.onBuyTicket, required this.onBuyPass});

  final VoidCallback? onBuyTicket;
  final VoidCallback? onBuyPass;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      backgroundColor: const Color(0xFFFFF4DA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD18A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFAB6A00),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Choose access to continue',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'You need a single ticket or an active pass before confirming this booking.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF7D663E),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: onBuyTicket,
            child: const Text('Buy single ticket'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onBuyPass, child: const Text('Buy a pass')),
        ],
      ),
    );
  }
}

class _AccessReadyCard extends StatelessWidget {
  const _AccessReadyCard({
    required this.title,
    required this.subtitle,
    required this.helperText,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String helperText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      backgroundColor: const Color(0xFFFFEEE3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE46F2A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF8C5028),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            helperText,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF8C5028),
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
