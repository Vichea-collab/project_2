import 'package:shared_preferences/shared_preferences.dart';

import '../../models/current_booking.dart';
import '../../models/ride_pass.dart';
import '../dtos/current_booking_dto.dart';
import '../dtos/ride_pass_dto.dart';
import 'ride_local_storage.dart';

class SharedPrefsRideLocalStorage implements RideLocalStorage {
  SharedPrefsRideLocalStorage({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  static const _activePassKey = 'ride_active_pass';
  static const _singleTicketKey = 'ride_single_ticket';
  static const _currentBookingKey = 'ride_current_booking';

  @override
  Future<RidePass?> loadActivePass() async {
    final raw = _preferences.getString(_activePassKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return RidePassDto.fromJsonString(raw).toDomain();
  }

  @override
  Future<void> saveActivePass(RidePass? pass) async {
    if (pass == null) {
      await _preferences.remove(_activePassKey);
      return;
    }
    await _preferences.setString(
      _activePassKey,
      RidePassDto.fromDomain(pass).toJsonString(),
    );
  }

  @override
  Future<bool> loadSingleTicket() async {
    return _preferences.getBool(_singleTicketKey) ?? false;
  }

  @override
  Future<void> saveSingleTicket(bool value) async {
    await _preferences.setBool(_singleTicketKey, value);
  }

  @override
  Future<CurrentBooking?> loadCurrentBooking() async {
    final raw = _preferences.getString(_currentBookingKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return CurrentBookingDto.fromJsonString(raw).toDomain();
  }

  @override
  Future<void> saveCurrentBooking(CurrentBooking? booking) async {
    if (booking == null) {
      await _preferences.remove(_currentBookingKey);
      return;
    }
    await _preferences.setString(
      _currentBookingKey,
      CurrentBookingDto.fromDomain(booking).toJsonString(),
    );
  }
}
