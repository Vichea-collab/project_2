import 'pass_type.dart';

class RidePass {
  const RidePass({required this.type, required this.purchasedAt});

  final PassType type;
  final DateTime purchasedAt;

  DateTime get expirationDate =>
      purchasedAt.add(Duration(days: type.validityDays));
}
