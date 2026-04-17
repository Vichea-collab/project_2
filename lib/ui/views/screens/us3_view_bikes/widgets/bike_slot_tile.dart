import 'package:flutter/material.dart';

import '../../../../../models/bike_slot.dart';

class BikeSlotTile extends StatelessWidget {
  const BikeSlotTile({super.key, required this.slot, required this.onTap});

  final BikeSlot slot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: slot.isAvailable
              ? const Color(0xFFFFFCFA)
              : const Color(0xFFF8F3EE),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: slot.isAvailable
                ? const Color(0xFFF0C5AA)
                : const Color(0xFFDDD2C8),
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
                    slot.isAvailable ? 'Ready' : 'Empty',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: slot.isAvailable
                          ? const Color(0xFFB84A10)
                          : const Color(0xFF726A64),
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
                      : const Color(0xFF91857D),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              slot.isAvailable ? 'Available bike' : 'Empty slot',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: slot.isAvailable
                    ? const Color(0xFF2A2725)
                    : const Color(0xFF5E5751),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              slot.isAvailable
                  ? 'Ready to reserve now'
                  : 'No bike parked in this slot',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: slot.isAvailable
                    ? const Color(0xFF544E48)
                    : const Color(0xFF746C65),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  slot.isAvailable
                      ? Icons.touch_app_rounded
                      : Icons.remove_circle_outline_rounded,
                  size: 18,
                  color: slot.isAvailable
                      ? const Color(0xFFE46F2A)
                      : const Color(0xFF7D736D),
                ),
                const SizedBox(width: 8),
                Text(
                  slot.isAvailable ? 'Tap to book' : 'Unavailable',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: slot.isAvailable
                        ? const Color(0xFFE46F2A)
                        : const Color(0xFF7D736D),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
