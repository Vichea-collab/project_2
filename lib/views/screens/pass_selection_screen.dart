import 'package:flutter/material.dart';

import '../../viewmodels/ride_app_view_model.dart';
import '../widgets/pass_option_card.dart';
import '../widgets/section_card.dart';

class PassSelectionScreen extends StatelessWidget {
  const PassSelectionScreen({
    super.key,
    required this.viewModel,
    this.selectionMode = false,
  });

  final RideAppViewModel viewModel;
  final bool selectionMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activePass = viewModel.activePass;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      children: [
        SectionCard(
          backgroundColor: const Color(0xFF2F2A27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Ride subscription',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                selectionMode
                    ? 'Select a pass'
                    : 'Choose the pass that fits you',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                activePass == null
                    ? 'Pick one active pass. Buying a new pass replaces the current one.'
                    : '${activePass.type.title} is active until ${_formatDate(activePass.expirationDate)}.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 18),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _HeroStat(value: '1', label: 'Tap purchase'),
                  _HeroStat(value: '24/7', label: 'Station access'),
                  _HeroStat(value: '∞', label: 'Short rides'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (activePass != null) ...[
          SectionCard(
            backgroundColor: const Color(0xFFFFEEE3),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE46F2A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${activePass.type.title} active',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Expires ${_formatDate(activePass.expirationDate)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF9C5429),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
        Text(
          selectionMode ? 'Available passes' : 'Available subscriptions',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          'Clean, modern cards aligned with your Figma direction.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final passType in viewModel.passTypes) ...[
          PassOptionCard(
            passType: passType,
            isActive: activePass?.type == passType,
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await viewModel.activatePass(passType);

              if (!context.mounted) {
                return;
              }

              if (selectionMode) {
                Navigator.of(context).pop(passType);
                return;
              }

              messenger.showSnackBar(
                SnackBar(content: Text('${passType.title} activated.')),
              );
            },
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.76),
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
