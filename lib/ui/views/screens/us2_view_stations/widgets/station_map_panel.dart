import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../models/bike_station.dart';

class StationMapPanel extends StatelessWidget {
  const StationMapPanel({
    super.key,
    required this.stations,
    required this.selectedStationId,
    required this.onSelect,
    this.accessLabel,
    this.fullScreen = false,
    this.showSelectedStationCard = true,
  });

  final List<BikeStation> stations;
  final String? selectedStationId;
  final ValueChanged<String> onSelect;
  final String? accessLabel;
  final bool fullScreen;
  final bool showSelectedStationCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    BikeStation? selectedStation;

    if (selectedStationId != null) {
      for (final station in stations) {
        if (station.id == selectedStationId) {
          selectedStation = station;
          break;
        }
      }
    }

    final map = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(fullScreen ? 0 : 30),
        boxShadow: fullScreen
            ? null
            : [
                BoxShadow(
                  blurRadius: 22,
                  offset: const Offset(0, 14),
                  color: Colors.black.withValues(alpha: 0.07),
                ),
              ],
      ),
      child: Padding(
        padding: EdgeInsets.all(fullScreen ? 0 : 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(fullScreen ? 0 : 24),
                    child: Container(
                      color: const Color(0xFFF3F2F0),
                      child: CustomPaint(
                        size: constraints.biggest,
                        painter: _MapBackdropPainter(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: fullScreen ? 14 : 8,
                  left: fullScreen ? 14 : 8,
                  right: fullScreen ? 14 : 8,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                                color: Colors.black.withValues(alpha: 0.05),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                color: Color(0xFF8A817B),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Search nearby stations',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF8A817B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _MapControlButton(icon: Icons.tune_rounded, onTap: () {}),
                    ],
                  ),
                ),
                Positioned(
                  top: fullScreen ? 68 : 62,
                  left: fullScreen ? 14 : 8,
                  right: fullScreen ? 62 : 56,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const _FilterChip(label: 'All', isSelected: true),
                        const SizedBox(width: 8),
                        const _FilterChip(label: 'Bikes'),
                        const SizedBox(width: 8),
                        const _FilterChip(label: 'Pass holders'),
                        if (accessLabel != null) ...[
                          const SizedBox(width: 8),
                          _FilterChip(label: accessLabel!),
                        ],
                      ],
                    ),
                  ),
                ),
                for (final station in stations)
                  Positioned(
                    left: station.mapX * (constraints.maxWidth - 72),
                    top:
                        station.mapY *
                        (constraints.maxHeight -
                            (showSelectedStationCard ? 170 : 90)),
                    child: _StationMarker(
                      station: station,
                      isSelected: selectedStationId == station.id,
                      onTap: () => onSelect(station.id),
                    ),
                  ),
                Positioned(
                  right: fullScreen ? 14 : 10,
                  bottom: showSelectedStationCard ? 112 : 24,
                  child: Column(
                    children: [
                      _MapControlButton(icon: Icons.add_rounded, onTap: () {}),
                      const SizedBox(height: 10),
                      _MapControlButton(
                        icon: Icons.my_location_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                if (selectedStation != null && showSelectedStationCard)
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE9DE),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.pedal_bike_rounded,
                              color: Color(0xFFE46F2A),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedStation.name,
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedStation.address,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _StatBadge(
                                      label:
                                          '${selectedStation.availableBikes} bikes',
                                    ),
                                    const SizedBox(width: 8),
                                    _StatBadge(
                                      label:
                                          '${selectedStation.totalSlots} slots',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );

    if (fullScreen) {
      return map;
    }

    return AspectRatio(aspectRatio: 0.86, child: map);
  }
}

class _StationMarker extends StatelessWidget {
  const _StationMarker({
    required this.station,
    required this.isSelected,
    required this.onTap,
  });

  final BikeStation station;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAvailability = station.availableBikes > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE46F2A)
              : hasAvailability
              ? const Color(0xFFFF7E3F)
              : const Color(0xFFC9B3A3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: isSelected ? 2.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isSelected ? 18 : 10,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: 0.14),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.pedal_bike_rounded,
              color: Colors.white,
              size: isSelected ? 24 : 20,
            ),
            const SizedBox(height: 4),
            Text(
              '${station.availableBikes}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFD8D5D1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final accentPaint = Paint()
      ..color = const Color(0xFFE6E3DF)
      ..style = PaintingStyle.fill;

    final river = Path()
      ..moveTo(size.width * 0.72, 0)
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.16,
        size.width * 0.8,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.8,
        size.width * 0.82,
        size.height,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(river, accentPaint);

    final roads = <Path>[
      Path()
        ..moveTo(size.width * 0.05, size.height * 0.14)
        ..quadraticBezierTo(
          size.width * 0.35,
          size.height * 0.2,
          size.width * 0.6,
          size.height * 0.08,
        ),
      Path()
        ..moveTo(size.width * 0.08, size.height * 0.48)
        ..quadraticBezierTo(
          size.width * 0.24,
          size.height * 0.34,
          size.width * 0.55,
          size.height * 0.38,
        )
        ..quadraticBezierTo(
          size.width * 0.74,
          size.height * 0.4,
          size.width * 0.92,
          size.height * 0.26,
        ),
      Path()
        ..moveTo(size.width * 0.16, size.height * 0.88)
        ..quadraticBezierTo(
          size.width * 0.34,
          size.height * 0.72,
          size.width * 0.58,
          size.height * 0.76,
        ),
      Path()
        ..moveTo(size.width * 0.28, size.height * 0.08)
        ..quadraticBezierTo(
          size.width * 0.22,
          size.height * 0.4,
          size.width * 0.3,
          size.height * 0.9,
        ),
      Path()
        ..moveTo(size.width * 0.54, size.height * 0.12)
        ..quadraticBezierTo(
          size.width * 0.52,
          size.height * 0.44,
          size.width * 0.64,
          size.height * 0.94,
        ),
    ];

    for (final road in roads) {
      canvas.drawPath(road, roadPaint);
    }

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFE6E2DE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < 6; index++) {
      final path = Path()
        ..moveTo(size.width * (0.1 + index * 0.12), size.height * 0.16)
        ..quadraticBezierTo(
          size.width * (0.18 + index * 0.1),
          size.height * 0.34,
          size.width * (0.1 + index * 0.08),
          size.height * 0.68,
        );
      canvas.drawPath(path, minorRoadPaint);
    }

    for (var index = 0; index < 7; index++) {
      final dx = size.width * (0.12 + index * 0.1);
      final dy = size.height * (0.18 + math.sin(index * 0.82) * 0.1 + 0.28);
      canvas.drawCircle(
        Offset(dx, dy),
        5,
        Paint()..color = const Color(0xFFF1EEEA),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE46F2A) : Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF5F5853),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: const Color(0xFF5F5853)),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2EC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF635B55),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
