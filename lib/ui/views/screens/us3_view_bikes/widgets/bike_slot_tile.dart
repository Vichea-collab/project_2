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
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: slot.isAvailable
                ? const Color(0xFFEBDDD0)
                : const Color(0xFFE2D9D1),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: 0.04),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: slot.isAvailable
                    ? const Color(0xFFFFEFE4)
                    : const Color(0xFFF3EFEB),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                slot.isAvailable
                    ? Icons.pedal_bike_rounded
                    : Icons.block_rounded,
                color: slot.isAvailable
                    ? const Color(0xFFE46F2A)
                    : const Color(0xFF9A8E84),
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: slot.isAvailable
                              ? const Color(0xFF2F6A46)
                              : const Color(0xFF9A8E84),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        slot.isAvailable ? 'Available' : 'Empty',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6E655E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                minimumSize: const Size(92, 44),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: slot.isAvailable
                    ? const Color(0xFFFF7E3F)
                    : const Color(0xFFCFC8C1),
              ),
              child: Text(slot.isAvailable ? 'Book now' : 'Unavailable'),
            ),
          ],
        ),
      ),
    );
  }
}
