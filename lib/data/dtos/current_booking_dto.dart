import 'dart:convert';

import '../../models/current_booking.dart';

class CurrentBookingDto {
  const CurrentBookingDto({
    required this.stationName,
    required this.slotLabel,
    required this.bookedAtIso,
  });

  final String stationName;
  final String slotLabel;
  final String bookedAtIso;

  factory CurrentBookingDto.fromDomain(CurrentBooking booking) {
    return CurrentBookingDto(
      stationName: booking.stationName,
      slotLabel: booking.slotLabel,
      bookedAtIso: booking.bookedAt.toIso8601String(),
    );
  }

  factory CurrentBookingDto.fromJsonString(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return CurrentBookingDto(
      stationName: (json['stationName'] ?? '').toString(),
      slotLabel: (json['slotLabel'] ?? '').toString(),
      bookedAtIso: (json['bookedAtIso'] ?? '').toString(),
    );
  }

  CurrentBooking toDomain() {
    return CurrentBooking(
      stationName: stationName,
      slotLabel: slotLabel,
      bookedAt: DateTime.parse(bookedAtIso),
    );
  }

  String toJsonString() {
    return jsonEncode({
      'stationName': stationName,
      'slotLabel': slotLabel,
      'bookedAtIso': bookedAtIso,
    });
  }
}
