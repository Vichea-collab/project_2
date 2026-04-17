import '../../models/bike_station.dart';
import '../../models/current_booking.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';

abstract class RideRepository {
  Future<List<PassType>> fetchPassTypes();
  Future<List<BikeStation>> fetchStations();
  Future<RidePass?> loadActivePass();
  Future<void> saveActivePass(RidePass? pass);
  Future<bool> loadSingleTicket();
  Future<void> saveSingleTicket(bool value);
  Future<CurrentBooking?> loadCurrentBooking();
  Future<void> saveCurrentBooking(CurrentBooking? booking);
  Future<void> bookBike({required String stationId, required String slotId});
}
