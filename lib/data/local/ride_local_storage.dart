import '../../models/current_booking.dart';
import '../../models/ride_pass.dart';

abstract class RideLocalStorage {
  Future<RidePass?> loadActivePass();
  Future<void> saveActivePass(RidePass? pass);
  Future<bool> loadSingleTicket();
  Future<void> saveSingleTicket(bool value);
  Future<CurrentBooking?> loadCurrentBooking();
  Future<void> saveCurrentBooking(CurrentBooking? booking);
}
