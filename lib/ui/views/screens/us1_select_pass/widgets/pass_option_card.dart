import 'package:flutter/material.dart';

import '../../../../../models/pass_type.dart';
import '../../../widgets/section_card.dart';

class PassOptionCard extends StatelessWidget {
  const PassOptionCard({
    super.key,
    required this.passType,
    required this.isActive,
    required this.onPressed,
    this.compact = false,
  });

  final PassType passType;
  final bool isActive;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = _styleForPass(passType);
    final daysLabel = passType.validityDays == 365
        ? '1 year'
        : '${passType.validityDays} days';

    return SectionCard(
      padding: EdgeInsets.all(compact ? 18 : 20),
      backgroundColor: style.background,
      borderSide: BorderSide(color: style.borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: compact ? 40 : 46,
                height: compact ? 40 : 46,
                decoration: BoxDecoration(
                  color: style.iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.pedal_bike_rounded, color: style.iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  passType.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: style.titleColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isActive ? style.activeBadge : style.badgeBackground,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isActive ? 'Active' : daysLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isActive ? Colors.white : style.badgeText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            passType.subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: style.subtitleColor,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: style.softBorderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule_rounded, color: style.iconColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _benefitLabel(passType),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5C5550),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                passType.priceLabel,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: style.titleColor,
                ),
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: isActive
                      ? const Color(0xFF2F2A27)
                      : style.buttonColor,
                  minimumSize: Size(compact ? 96 : 108, 46),
                ),
                onPressed: onPressed,
                child: Text(isActive ? 'Replace' : 'Select'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _benefitLabel(PassType type) {
  switch (type) {
    case PassType.day:
      return 'Unlimited short rides for 24 hours';
    case PassType.monthly:
      return 'Unlimited access for your monthly commute';
    case PassType.annual:
      return 'Best value for long-term daily riders';
  }
}

_PassCardStyle _styleForPass(PassType type) {
  switch (type) {
    case PassType.day:
      return const _PassCardStyle(
        background: Color(0xFFF8D2BD),
        titleColor: Color(0xFF6E2F10),
        subtitleColor: Color(0xFF704A39),
        badgeBackground: Color(0xFFFFEBD9),
        badgeText: Color(0xFF914314),
        activeBadge: Color(0xFFE46F2A),
        buttonColor: Color(0xFFE46F2A),
        iconBackground: Color(0xFFFFE9DE),
        iconColor: Color(0xFFC85516),
        borderColor: Color(0xFFF0BA99),
        softBorderColor: Color(0xFFF3D8C8),
      );
    case PassType.monthly:
      return const _PassCardStyle(
        background: Color(0xFFFFFCFA),
        titleColor: Color(0xFF2A2725),
        subtitleColor: Color(0xFF59534F),
        badgeBackground: Color(0xFFF6EEE7),
        badgeText: Color(0xFF6B5446),
        activeBadge: Color(0xFFE46F2A),
        buttonColor: Color(0xFFE46F2A),
        iconBackground: Color(0xFFFFFFFF),
        iconColor: Color(0xFF2E2A27),
        borderColor: Color(0xFFE7D7CA),
        softBorderColor: Color(0xFFECE2DA),
      );
    case PassType.annual:
      return const _PassCardStyle(
        background: Color(0xFFFFFCFA),
        titleColor: Color(0xFF2A2725),
        subtitleColor: Color(0xFF59534F),
        badgeBackground: Color(0xFFF6EEE7),
        badgeText: Color(0xFF6B5446),
        activeBadge: Color(0xFFE46F2A),
        buttonColor: Color(0xFFE46F2A),
        iconBackground: Color(0xFFFFFFFF),
        iconColor: Color(0xFF2E2A27),
        borderColor: Color(0xFFE7D7CA),
        softBorderColor: Color(0xFFECE2DA),
      );
  }
}

class _PassCardStyle {
  const _PassCardStyle({
    required this.background,
    required this.titleColor,
    required this.subtitleColor,
    required this.badgeBackground,
    required this.badgeText,
    required this.activeBadge,
    required this.buttonColor,
    required this.iconBackground,
    required this.iconColor,
    required this.borderColor,
    required this.softBorderColor,
  });

  final Color background;
  final Color titleColor;
  final Color subtitleColor;
  final Color badgeBackground;
  final Color badgeText;
  final Color activeBadge;
  final Color buttonColor;
  final Color iconBackground;
  final Color iconColor;
  final Color borderColor;
  final Color softBorderColor;
}
