class CurrentBooking {
  const CurrentBooking({
    required this.stationName,
    required this.slotLabel,
    required this.bookedAt,
  });

  final String stationName;
  final String slotLabel;
  final DateTime bookedAt;
}
