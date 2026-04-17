import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/bike_station.dart';
import '../../models/current_booking.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';
import '../dtos/bike_station_dto.dart';
import '../firebase/ride_database_schema.dart';
import '../local/ride_local_storage.dart';
import 'ride_repository.dart';

class RideRestRepository implements RideRepository {
  RideRestRepository({
    required String databaseUrl,
    required RideLocalStorage localStorage,
    http.Client? client,
  }) : _databaseUrl = databaseUrl.replaceFirst(RegExp(r'/$'), ''),
       _localStorage = localStorage,
       _client = client ?? http.Client();

  final String _databaseUrl;
  final RideLocalStorage _localStorage;
  final http.Client _client;

  Uri _uri(String path, [Map<String, String>? queryParameters]) => Uri.parse(
    '$_databaseUrl/$path.json',
  ).replace(queryParameters: queryParameters);

  @override
  Future<List<PassType>> fetchPassTypes() async {
    return PassType.values;
  }

  @override
  Future<List<BikeStation>> fetchStations() async {
    final response = await _client.get(_uri(RideDatabaseSchema.stations));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to fetch stations.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return <BikeStation>[];
    }

    final stations = <BikeStation>[];
    for (final entry in decoded.entries) {
      final value = entry.value;
      if (value is Map) {
        stations.add(
          BikeStationDto.fromMap(
            entry.key,
            Map<Object?, Object?>.from(value),
          ).toDomain(),
        );
      }
    }

    stations.sort((a, b) => a.name.compareTo(b.name));
    return stations;
  }

  @override
  Future<RidePass?> loadActivePass() => _localStorage.loadActivePass();

  @override
  Future<void> saveActivePass(RidePass? pass) =>
      _localStorage.saveActivePass(pass);

  @override
  Future<bool> loadSingleTicket() => _localStorage.loadSingleTicket();

  @override
  Future<void> saveSingleTicket(bool value) =>
      _localStorage.saveSingleTicket(value);

  @override
  Future<CurrentBooking?> loadCurrentBooking() =>
      _localStorage.loadCurrentBooking();

  @override
  Future<void> saveCurrentBooking(CurrentBooking? booking) =>
      _localStorage.saveCurrentBooking(booking);

  @override
  Future<void> bookBike({
    required String stationId,
    required String slotId,
  }) async {
    final slotPath =
        '${RideDatabaseSchema.stations}/$stationId/${RideDatabaseSchema.stationSlots}/$slotId';
    final slotUri = _uri(slotPath);

    final getResponse = await _client.get(
      slotUri,
      headers: const {'X-Firebase-ETag': 'true'},
    );

    if (getResponse.statusCode < 200 || getResponse.statusCode >= 300) {
      throw Exception('Unable to load the selected bike slot.');
    }

    final etag = getResponse.headers['etag'];
    final decoded = jsonDecode(getResponse.body);

    if (etag == null || decoded is! Map) {
      throw Exception('Invalid bike slot response.');
    }

    final currentSlot = Map<String, dynamic>.from(decoded);
    if (currentSlot[RideDatabaseSchema.slotIsAvailable] != true) {
      throw Exception('Bike is no longer available.');
    }

    final updatedSlot = <String, dynamic>{
      ...currentSlot,
      RideDatabaseSchema.slotIsAvailable: false,
    };

    final putResponse = await _client.put(
      slotUri,
      headers: {'if-match': etag, 'content-type': 'application/json'},
      body: jsonEncode(updatedSlot),
    );

    if (putResponse.statusCode == 412) {
      throw Exception('Bike is no longer available.');
    }

    if (putResponse.statusCode < 200 || putResponse.statusCode >= 300) {
      throw Exception('Unable to confirm the booking.');
    }
  }
}
