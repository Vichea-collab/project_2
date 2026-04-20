import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';

class RidePassDto {
  const RidePassDto({required this.typeName, required this.purchasedAtIso});

  final String typeName;
  final String purchasedAtIso;

  factory RidePassDto.fromDomain(RidePass pass) {
    return RidePassDto(
      typeName: pass.type.name,
      purchasedAtIso: pass.purchasedAt.toIso8601String(),
    );
  }

  factory RidePassDto.fromMap(Map<Object?, Object?> source) {
    return RidePassDto(
      typeName: (source['typeName'] ?? '').toString(),
      purchasedAtIso: (source['purchasedAtIso'] ?? '').toString(),
    );
  }

  RidePass toDomain() {
    return RidePass(
      type: PassType.values.firstWhere(
        (item) => item.name == typeName,
        orElse: () => PassType.day,
      ),
      purchasedAt: DateTime.parse(purchasedAtIso),
    );
  }

  Map<String, dynamic> toMap() {
    return {'typeName': typeName, 'purchasedAtIso': purchasedAtIso};
  }
}
