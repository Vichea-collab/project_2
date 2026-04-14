import 'package:flutter/material.dart';

import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/section_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.viewModel});

  final RideAppViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activePass = viewModel.activePass;
    final currentBooking = viewModel.currentBooking;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      children: [
        SectionCard(
          backgroundColor: const Color(0xFF2F2A27),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Orange Rider',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Manage your bookings, ride access, and support from one account screen.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionCard(
          backgroundColor: const Color(0xFFFFEEE3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ride access', style: theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(
                activePass == null
                    ? 'No active pass on this account.'
                    : '${activePass.type.title} active until ${_formatDate(activePass.expirationDate)}.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF8C5028),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Badge(text: viewModel.accessLabel),
                  _Badge(
                    text: currentBooking == null
                        ? 'No reservation'
                        : 'Booking ready',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (currentBooking != null)
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current booking', style: theme.textTheme.titleLarge),
                const SizedBox(height: 14),
                _InfoRow(label: 'Station', value: currentBooking.stationName),
                const SizedBox(height: 12),
                _InfoRow(label: 'Slot', value: currentBooking.slotLabel),
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Reserved at',
                  value: _formatTime(currentBooking.bookedAt),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => viewModel.changeTab(0),
                  child: const Text('Open in history'),
                ),
              ],
            ),
          )
        else
          SectionCard(
            backgroundColor: const Color(0xFFFFF4DA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking status', style: theme.textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(
                  'You have no active reservation. Open the stations tab to start a booking.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF7D663E),
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () => viewModel.changeTab(1),
                  child: const Text('Go to stations'),
                ),
              ],
            ),
          ),
        const SizedBox(height: 18),
        Text('Preferences', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        const _SettingTile(
          icon: Icons.notifications_active_outlined,
          title: 'Notifications',
          subtitle: 'Ride reminders and station updates',
        ),
        const SizedBox(height: 12),
        const _SettingTile(
          icon: Icons.payment_rounded,
          title: 'Payment methods',
          subtitle: 'Manage saved cards and billing',
        ),
        const SizedBox(height: 12),
        const _SettingTile(
          icon: Icons.help_outline_rounded,
          title: 'Help center',
          subtitle: 'Get support for passes and bookings',
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEFE4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFFE46F2A)),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF7F4A25),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
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

String _formatTime(DateTime date) {
  final hour = date.hour == 0
      ? 12
      : (date.hour > 12 ? date.hour - 12 : date.hour);
  final minute = date.minute.toString().padLeft(2, '0');
  final suffix = date.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}
