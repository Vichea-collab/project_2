import 'package:flutter/material.dart';

import '../../data/models/bike_slot.dart';

class BikeSlotTile extends StatelessWidget {
  const BikeSlotTile({super.key, required this.slot, required this.onTap});

  final BikeSlot slot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: slot.isAvailable
                ? const Color(0xFFFFE0D0)
                : const Color(0xFFE8E0D8),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: 0.04),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: slot.isAvailable
                        ? const Color(0xFFFFEFE4)
                        : const Color(0xFFF1ECE7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    slot.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: slot.isAvailable
                          ? const Color(0xFFD96421)
                          : const Color(0xFF90867F),
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  slot.isAvailable
                      ? Icons.pedal_bike_rounded
                      : Icons.block_rounded,
                  color: slot.isAvailable
                      ? const Color(0xFFE46F2A)
                      : const Color(0xFFB6AAA2),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              slot.isAvailable ? 'Available bike' : 'Empty slot',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              slot.isAvailable
                  ? 'Ready to reserve now'
                  : 'No bike parked in this slot',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: slot.isAvailable
                    ? const Color(0xFFE46F2A)
                    : const Color(0xFFF1ECE7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                slot.isAvailable ? 'Book now' : 'Unavailable',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: slot.isAvailable
                      ? Colors.white
                      : const Color(0xFF9B8F87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
