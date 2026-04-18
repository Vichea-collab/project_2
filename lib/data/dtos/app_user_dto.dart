import '../../models/app_user.dart';
import '../../models/current_booking.dart';
import 'current_booking_dto.dart';
import 'ride_pass_dto.dart';

class AppUserDto {
  const AppUserDto({
    required this.id,
    required this.name,
    required this.hasSingleTicket,
    this.activePass,
    this.bookingHistory = const [],
  });

  final String id;
  final String name;
  final RidePassDto? activePass;
  final bool hasSingleTicket;
  final List<CurrentBookingDto> bookingHistory;

  factory AppUserDto.fromDomain(AppUser user) {
    return AppUserDto(
      id: user.id,
      name: user.name,
      activePass: user.activePass == null
          ? null
          : RidePassDto.fromDomain(user.activePass!),
      hasSingleTicket: user.hasSingleTicket,
      bookingHistory: user.bookingHistory
          .map(CurrentBookingDto.fromDomain)
          .toList(),
    );
  }

  factory AppUserDto.fromMap(String id, Map<Object?, Object?> source) {
    final rawActivePass = source['activePass'];
    final rawBookingHistory = source['bookingHistory'];
    final rawCurrentBooking = source['currentBooking'];

    final bookingHistory = _parseBookingHistory(
      rawBookingHistory,
      rawCurrentBooking,
    );

    return AppUserDto(
      id: id,
      name: (source['name'] ?? source['fullName'] ?? 'Guest Rider').toString(),
      activePass: rawActivePass is Map
          ? RidePassDto.fromMap(Map<Object?, Object?>.from(rawActivePass))
          : null,
      hasSingleTicket: source['hasSingleTicket'] == true,
      bookingHistory: bookingHistory,
    );
  }

  AppUser toDomain() {
    return AppUser(
      id: id,
      name: name,
      activePass: activePass?.toDomain(),
      hasSingleTicket: hasSingleTicket,
      bookingHistory: bookingHistory
          .map<CurrentBooking>((booking) => booking.toDomain())
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'activePass': activePass?.toMap(),
      'hasSingleTicket': hasSingleTicket,
      'bookingHistory': bookingHistory
          .map((booking) => booking.toMap())
          .toList(),
    };
  }

  static List<CurrentBookingDto> _parseBookingHistory(
    Object? rawBookingHistory,
    Object? rawCurrentBooking,
  ) {
    final history = <CurrentBookingDto>[];

    if (rawBookingHistory is List) {
      for (final item in rawBookingHistory) {
        if (item is Map) {
          history.add(
            CurrentBookingDto.fromMap(Map<Object?, Object?>.from(item)),
          );
        }
      }
    } else if (rawBookingHistory is Map) {
      for (final item in rawBookingHistory.values) {
        if (item is Map) {
          history.add(
            CurrentBookingDto.fromMap(Map<Object?, Object?>.from(item)),
          );
        }
      }
    }

    if (history.isEmpty && rawCurrentBooking is Map) {
      history.add(
        CurrentBookingDto.fromMap(
          Map<Object?, Object?>.from(rawCurrentBooking),
        ),
      );
    }

    history.sort((a, b) => b.bookedAtIso.compareTo(a.bookedAtIso));
    return history;
  }
}
