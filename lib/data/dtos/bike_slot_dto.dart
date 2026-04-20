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
      label: (map[RideApiSchema.slotLabel] ?? id).toString(),
      isAvailable: map[RideApiSchema.slotIsAvailable] == true,
    );
  }

  BikeSlot toDomain() {
    return BikeSlot(id: id, label: label, isAvailable: isAvailable);
  }

  Map<String, Object?> toMap() {
    return {
      RideApiSchema.slotId: id,
      RideApiSchema.slotLabel: label,
      RideApiSchema.slotIsAvailable: isAvailable,
    };
  }
}
