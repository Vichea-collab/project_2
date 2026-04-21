import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../models/app_user.dart';
import '../../dtos/app_user_dto.dart';
import '../../mockup_data.dart';

abstract class UserRepository {
  Future<AppUser> fetchCurrentUser();
  Future<void> saveCurrentUser(AppUser user);
}

class UserRestRepository implements UserRepository {
  UserRestRepository({required String databaseUrl, http.Client? client})
    : databaseUrl = databaseUrl.replaceFirst(RegExp(r'/$'), ''),
      _client = client ?? http.Client();

  final String databaseUrl;
  final http.Client _client;
  static const String defaultUserId = 'u-001';

  Uri _uri(String path, [Map<String, String>? queryParameters]) => Uri.parse(
    '$databaseUrl/$path.json',
  ).replace(queryParameters: queryParameters);

  @override
  Future<AppUser> fetchCurrentUser() async {
    final response = await _client.get(_uri('users/$defaultUserId'));

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
      _uri('users/${user.id}'),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode(AppUserDto.fromDomain(user).toMap()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to save the current user.');
    }
  }
}

class UserMockRepository implements UserRepository {
  const UserMockRepository({required MockRideStore store}) : _store = store;

  final MockRideStore _store;

  @override
  Future<AppUser> fetchCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _store.currentUser;
  }

  @override
  Future<void> saveCurrentUser(AppUser user) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _store.currentUser = user;
  }
}
