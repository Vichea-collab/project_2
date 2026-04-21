import '../../models/app_user.dart';
import 'ride_pass_dto.dart';

class AppUserDto {
  const AppUserDto({required this.id, required this.name, this.activePass});

  final String id;
  final String name;
  final RidePassDto? activePass;

  factory AppUserDto.fromDomain(AppUser user) {
    return AppUserDto(
      id: user.id,
      name: user.name,
      activePass: user.activePass == null
          ? null
          : RidePassDto.fromDomain(user.activePass!),
    );
  }

  factory AppUserDto.fromMap(String id, Map<Object?, Object?> source) {
    final rawActivePass = source['activePass'];

    return AppUserDto(
      id: id,
      name: (source['name'] ?? source['fullName'] ?? 'Guest Rider').toString(),
      activePass: rawActivePass is Map
          ? RidePassDto.fromMap(Map<Object?, Object?>.from(rawActivePass))
          : null,
    );
  }

  AppUser toDomain() {
    return AppUser(id: id, name: name, activePass: activePass?.toDomain());
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'activePass': activePass?.toMap()};
  }
}
