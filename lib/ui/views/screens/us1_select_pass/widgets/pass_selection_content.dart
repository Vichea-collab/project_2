import 'package:flutter/material.dart';

import '../../../widgets/section_card.dart';
import '../view_model/pass_selection_view_model.dart';
import 'pass_option_card.dart';

class PassSelectionContent extends StatelessWidget {
  const PassSelectionContent({
    super.key,
    required this.viewModel,
    required this.onSelectPass,
    required this.onCancelPass,
  });

  final PassSelectionViewModel viewModel;
  final ValueChanged<int> onSelectPass;
  final VoidCallback onCancelPass;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activePassType = viewModel.activePassType;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      children: [
        if (viewModel.selectionMode) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2ECE5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Step 2',
              style: theme.textTheme.labelMedium?.copyWith(
                color: const Color(0xFF5B534D),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        SectionCard(
          backgroundColor: const Color(0xFFFFF4EC),
          borderSide: const BorderSide(color: Color(0xFFF1DACA)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.heroTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF2C2521),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                viewModel.heroSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF6B625B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (activePassType != null) ...[
          SectionCard(
            backgroundColor: const Color(0xFFFFEEE3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE46F2A),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                      ),
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
                            'Expires ${viewModel.activePassExpirationLabel}.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF9C5429),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            viewModel.selectionMode
                                ? 'Selecting a different pass will replace the current one for this booking.'
                                : 'Your next booking can use this pass directly.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF9C5429),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!viewModel.selectionMode) ...[
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: onCancelPass,
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Cancel subscription'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
        Text(
          viewModel.selectionMode
              ? 'Step 2 options'
              : 'Available subscriptions',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          viewModel.selectionMode
              ? 'Choose a pass to continue directly to the success screen.'
              : 'Choose one pass type to unlock repeated rentals.',
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
