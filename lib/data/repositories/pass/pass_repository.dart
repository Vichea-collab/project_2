import '../../../models/pass_type.dart';

abstract class PassRepository {
  Future<List<PassType>> fetchPassTypes();
}

class PassRestRepository implements PassRepository {
  const PassRestRepository();

  @override
  Future<List<PassType>> fetchPassTypes() async => PassType.values;
}

class PassMockRepository implements PassRepository {
  const PassMockRepository();

  @override
  Future<List<PassType>> fetchPassTypes() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return PassType.values;
  }
}
