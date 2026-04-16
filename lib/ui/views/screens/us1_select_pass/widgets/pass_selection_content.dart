import 'package:flutter/material.dart';

import '../../../widgets/section_card.dart';
import '../view_model/pass_selection_view_model.dart';
import 'pass_option_card.dart';

class PassSelectionContent extends StatelessWidget {
  const PassSelectionContent({
    super.key,
    required this.viewModel,
    required this.onSelectPass,
  });

  final PassSelectionViewModel viewModel;
  final ValueChanged<int> onSelectPass;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activePassType = viewModel.activePassType;

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
                  'US1 · Select a Pass',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                viewModel.heroTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                viewModel.heroSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 18),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _HeroStat(value: '1', label: 'Active pass'),
                  _HeroStat(value: '24/7', label: 'Station access'),
                  _HeroStat(value: '∞', label: 'Short rides'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (activePassType != null) ...[
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
                        '${activePassType.title} active',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your next booking can use this pass directly.',
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
          viewModel.selectionMode
              ? 'Available passes'
              : 'Available subscriptions',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          'Choose one pass type to unlock repeated rentals.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (var index = 0; index < viewModel.passTypes.length; index++) ...[
          PassOptionCard(
            passType: viewModel.passTypes[index],
            isActive: activePassType == viewModel.passTypes[index],
            onPressed: () => onSelectPass(index),
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
