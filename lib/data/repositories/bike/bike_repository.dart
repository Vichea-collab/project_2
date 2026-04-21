import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../mockup_data.dart';

abstract class BikeRepository {
  Future<void> bookBike({required String stationId, required String slotId});
}

class BikeRestRepository implements BikeRepository {
  BikeRestRepository({required String databaseUrl, http.Client? client})
    : databaseUrl = databaseUrl.replaceFirst(RegExp(r'/$'), ''),
      _client = client ?? http.Client();

  final String databaseUrl;
  final http.Client _client;

  Uri _uri(String path, [Map<String, String>? queryParameters]) => Uri.parse(
    '$databaseUrl/$path.json',
  ).replace(queryParameters: queryParameters);

  @override
  Future<void> bookBike({
    required String stationId,
    required String slotId,
  }) async {
    final slotUri = _uri('stations/$stationId/slots/$slotId');

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
    if (currentSlot['isAvailable'] != true) {
      throw Exception('Bike is no longer available.');
    }

    final updatedSlot = <String, dynamic>{...currentSlot, 'isAvailable': false};

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

class BikeMockRepository implements BikeRepository {
  const BikeMockRepository({required MockRideStore store}) : _store = store;

  final MockRideStore _store;

  @override
  Future<void> bookBike({
    required String stationId,
    required String slotId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    _store.stations = _store.stations.map((station) {
      if (station.id != stationId) {
        return station;
      }

      final slots = station.slots
          .map(
            (slot) =>
                slot.id == slotId ? slot.copyWith(isAvailable: false) : slot,
          )
          .toList();

      return station.copyWith(slots: slots);
    }).toList();
  }
}
