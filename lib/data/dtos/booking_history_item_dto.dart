import 'dart:convert';

import '../../models/booking_history_item.dart';

class BookingHistoryItemDto {
  const BookingHistoryItemDto({
    required this.stationName,
    required this.slotLabel,
    required this.bookedAtIso,
  });

  final String stationName;
  final String slotLabel;
  final String bookedAtIso;

  factory BookingHistoryItemDto.fromDomain(BookingHistoryItem booking) {
    return BookingHistoryItemDto(
      stationName: booking.stationName,
      slotLabel: booking.slotLabel,
      bookedAtIso: booking.bookedAt.toIso8601String(),
    );
  }

  factory BookingHistoryItemDto.fromJsonString(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return BookingHistoryItemDto(
      stationName: (json['stationName'] ?? '').toString(),
      slotLabel: (json['slotLabel'] ?? '').toString(),
      bookedAtIso: (json['bookedAtIso'] ?? '').toString(),
    );
  }

  factory BookingHistoryItemDto.fromMap(Map<Object?, Object?> source) {
    return BookingHistoryItemDto(
      stationName: (source['stationName'] ?? '').toString(),
      slotLabel: (source['slotLabel'] ?? '').toString(),
      bookedAtIso: (source['bookedAtIso'] ?? '').toString(),
    );
  }

  BookingHistoryItem toDomain() {
    return BookingHistoryItem(
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

  Map<String, dynamic> toMap() {
    return {
      'stationName': stationName,
      'slotLabel': slotLabel,
      'bookedAtIso': bookedAtIso,
    };
  }
}
