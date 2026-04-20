import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/app_user.dart';
import '../../models/bike_station.dart';
import '../../models/pass_type.dart';
import '../api/ride_api_schema.dart';
import '../dtos/app_user_dto.dart';
import '../dtos/bike_station_dto.dart';
import 'ride_repository.dart';

class RideRestRepository implements RideRepository {
  RideRestRepository({required String databaseUrl, http.Client? client})
    : databaseUrl = databaseUrl.replaceFirst(RegExp(r'/$'), ''),
      _client = client ?? http.Client();

  final String databaseUrl;
  final http.Client _client;
  static const String defaultUserId = 'u-001';

  Uri _uri(String path, [Map<String, String>? queryParameters]) => Uri.parse(
    '$databaseUrl/$path.json',
  ).replace(queryParameters: queryParameters);

  @override
  Future<List<PassType>> fetchPassTypes() async {
    return PassType.values;
  }

  @override
  Future<List<BikeStation>> fetchStations() async {
    final response = await _client.get(_uri(apiPathStations));

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
  Future<AppUser> fetchCurrentUser() async {
    final response = await _client.get(
      _uri('$apiPathUsers/$defaultUserId'),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to fetch the current user.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      return const AppUser(id: defaultUserId, name: 'Guest Rider');
    }

    return AppUserDto.fromMap(
      defaultUserId,
      Map<Object?, Object?>.from(decoded),
    ).toDomain();
  }

  @override
  Future<void> saveCurrentUser(AppUser user) async {
    final response = await _client.put(
      _uri('$apiPathUsers/${user.id}'),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode(AppUserDto.fromDomain(user).toMap()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to save the current user.');
    }
  }

  @override
  Future<void> bookBike({
    required String stationId,
    required String slotId,
  }) async {
    final slotPath =
        '$apiPathStations/$stationId/$apiStationSlots/$slotId';
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
    if (currentSlot[apiSlotIsAvailable] != true) {
      throw Exception('Bike is no longer available.');
    }

    final updatedSlot = <String, dynamic>{
      ...currentSlot,
      apiSlotIsAvailable: false,
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
