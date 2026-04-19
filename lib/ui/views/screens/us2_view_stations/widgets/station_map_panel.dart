import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../models/bike_station.dart';

class StationMapPanel extends StatefulWidget {
  const StationMapPanel({
    super.key,
    required this.stations,
    required this.selectedStationId,
    required this.onSelect,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
    this.accessLabel,
    this.fullScreen = false,
    this.showSelectedStationCard = true,
  });

  final List<BikeStation> stations;
  final String? selectedStationId;
  final ValueChanged<String> onSelect;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final String? accessLabel;
  final bool fullScreen;
  final bool showSelectedStationCard;

  @override
  State<StationMapPanel> createState() => _StationMapPanelState();
}

class _StationMapPanelState extends State<StationMapPanel> {
  late final TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _zoom(double factor) {
    final currentMatrix = _transformationController.value.clone();
    final currentScale = currentMatrix.getMaxScaleOnAxis();
    final targetScale = (currentScale * factor).clamp(1.0, 2.4);
    final normalizedFactor = targetScale / currentScale;
    currentMatrix.multiply(
      Matrix4.diagonal3Values(normalizedFactor, normalizedFactor, 1),
    );
    _transformationController.value = currentMatrix;
  }

  void _resetView() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    BikeStation? selectedStation;

    if (widget.selectedStationId != null) {
      for (final station in widget.stations) {
        if (station.id == widget.selectedStationId) {
          selectedStation = station;
          break;
        }
      }
    }

    final map = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.fullScreen ? 0 : 30),
        boxShadow: widget.fullScreen
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
        padding: EdgeInsets.all(widget.fullScreen ? 0 : 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final reservedBottomSpace = widget.showSelectedStationCard ? 150.0 : 70.0;
            final mapWidth = math.max(constraints.maxWidth * 1.45, constraints.maxWidth + 220);
            final mapHeight = math.max(
              constraints.maxHeight * 1.28,
              constraints.maxHeight + reservedBottomSpace,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.fullScreen ? 0 : 24),
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: const EdgeInsets.all(180),
                      constrained: false,
                      minScale: 1,
                      maxScale: 2.4,
                      child: SizedBox(
                        width: mapWidth,
                        height: mapHeight,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                color: const Color(0xFFF3F2F0),
                                child: CustomPaint(
                                  size: Size(mapWidth, mapHeight),
                                  painter: _MapBackdropPainter(),
                                ),
                              ),
                            ),
                            for (final station in widget.stations)
                              Positioned(
                                left: station.mapX * (mapWidth - 72),
                                top: station.mapY * (mapHeight - reservedBottomSpace),
                                child: _StationMarker(
                                  station: station,
                                  isSelected: widget.selectedStationId == station.id,
                                  onTap: () => widget.onSelect(station.id),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: widget.fullScreen ? 14 : 8,
                  left: widget.fullScreen ? 14 : 8,
                  right: widget.fullScreen ? 14 : 8,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
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
                          child: TextField(
                            controller: widget.searchController,
                            onChanged: widget.onSearchChanged,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Search nearby stations',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF8A817B),
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: Color(0xFF8A817B),
                              ),
                              suffixIcon: widget.searchController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      onPressed: widget.onClearSearch,
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0xFF8A817B),
                                      ),
                                    ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _MapControlButton(icon: Icons.tune_rounded, onTap: () {}),
                    ],
                  ),
                ),
                Positioned(
                  right: widget.fullScreen ? 14 : 10,
                  bottom: widget.showSelectedStationCard ? 112 : 24,
                  child: Column(
                    children: [
                      _MapControlButton(
                        icon: Icons.add_rounded,
                        onTap: () => _zoom(1.18),
                      ),
                      const SizedBox(height: 10),
                      _MapControlButton(
                        icon: Icons.my_location_rounded,
                        onTap: _resetView,
                      ),
                    ],
                  ),
                ),
                if (selectedStation != null && widget.showSelectedStationCard)
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
                                          '${selectedStation.availableBikes} bikes ready',
                                    ),
                                    const SizedBox(width: 8),
                                    _StatBadge(
                                      label:
                                          '${selectedStation.totalSlots} total slots',
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

    if (widget.fullScreen) {
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
