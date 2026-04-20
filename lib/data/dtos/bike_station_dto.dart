import '../../models/bike_station.dart';
import '../api/ride_api_schema.dart';
import 'bike_slot_dto.dart';

class BikeStationDto {
  const BikeStationDto({
    required this.id,
    required this.name,
    required this.address,
    required this.mapX,
    required this.mapY,
    required this.slots,
  });

  final String id;
  final String name;
  final String address;
  final double mapX;
  final double mapY;
  final List<BikeSlotDto> slots;

  factory BikeStationDto.fromMap(String id, Map<Object?, Object?> map) {
    final rawSlots = map[apiStationSlots];
    final slots = <BikeSlotDto>[];

    if (rawSlots is Map) {
      for (final entry in rawSlots.entries) {
        final value = entry.value;
        if (value is Map<Object?, Object?>) {
          slots.add(BikeSlotDto.fromMap(entry.key.toString(), value));
        }
      }
    } else if (rawSlots is List) {
      for (final item in rawSlots) {
        if (item is Map<Object?, Object?>) {
          final slotId = (item['id'] ?? item['label'] ?? 'slot').toString();
          slots.add(BikeSlotDto.fromMap(slotId, item));
        }
      }
    }

    return BikeStationDto(
      id: id,
      name: (map[apiStationName] ?? '').toString(),
      address: (map[apiStationAddress] ?? '').toString(),
      mapX: toDoubleValue(map[apiStationMapX]),
      mapY: toDoubleValue(map[apiStationMapY]),
      slots: slots,
    );
  }

  BikeStation toDomain() {
    return BikeStation(
      id: id,
      name: name,
      address: address,
      mapX: mapX,
      mapY: mapY,
      slots: slots.map((slot) => slot.toDomain()).toList(),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      apiStationName: name,
      apiStationAddress: address,
      apiStationMapX: mapX,
      apiStationMapY: mapY,
      apiStationSlots: {
        for (final slot in slots) slot.id: slot.toMap(),
      },
    };
  }
}

double toDoubleValue(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return 0;
}
