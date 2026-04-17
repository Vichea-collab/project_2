import 'package:flutter/material.dart';

class BookingFlowBackground extends StatelessWidget {
  const BookingFlowBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8F4EE), Color(0xFFF1ECE5)],
        ),
      ),
      child: child,
    );
  }
}

class BookingFlowStepHeader extends StatelessWidget {
  const BookingFlowStepHeader({
    super.key,
    required this.step,
    required this.title,
    required this.description,
  });

  final String step;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF2ECE5),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            step,
            style: theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFF5B534D),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF655E58),
          ),
        ),
      ],
    );
  }
}

class BookingFlowDetailRow extends StatelessWidget {
  const BookingFlowDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF6C645E),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style:
              (emphasize
                      ? theme.textTheme.titleLarge
                      : theme.textTheme.titleMedium)
                  ?.copyWith(fontWeight: FontWeight.w800, color: valueColor),
        ),
      ],
    );
  }
}
