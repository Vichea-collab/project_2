import 'booking_history_item.dart';
import 'ride_pass.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    this.activePass,
    this.hasSingleTicket = false,
    this.bookingHistory = const [],
  });

  final String id;
  final String name;
  final RidePass? activePass;
  final bool hasSingleTicket;
  final List<BookingHistoryItem> bookingHistory;

  AppUser copyWith({
    String? id,
    String? name,
    Object? activePass = _sentinel,
    bool? hasSingleTicket,
    List<BookingHistoryItem>? bookingHistory,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      activePass: identical(activePass, _sentinel)
          ? this.activePass
          : activePass as RidePass?,
      hasSingleTicket: hasSingleTicket ?? this.hasSingleTicket,
      bookingHistory: bookingHistory ?? this.bookingHistory,
    );
  }
}

const _sentinel = Object();
