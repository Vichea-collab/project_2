import '../../models/bike_slot.dart';
import '../api/ride_api_schema.dart';

class BikeSlotDto {
  const BikeSlotDto({
    required this.id,
    required this.label,
    required this.isAvailable,
  });

  final String id;
  final String label;
  final bool isAvailable;

  factory BikeSlotDto.fromMap(String id, Map<Object?, Object?> map) {
    return BikeSlotDto(
      id: id,
      label: (map[apiSlotLabel] ?? id).toString(),
      isAvailable: map[apiSlotIsAvailable] == true,
    );
  }

  BikeSlot toDomain() {
    return BikeSlot(id: id, label: label, isAvailable: isAvailable);
  }

  Map<String, Object?> toMap() {
    return {
      apiSlotId: id,
      apiSlotLabel: label,
      apiSlotIsAvailable: isAvailable,
    };
  }
}
