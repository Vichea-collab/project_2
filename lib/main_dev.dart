import 'data/repositories/ride_repository_factory.dart';
import 'main_common.dart';

Future<void> main() async {
  await mainCommon(createRepositories: RideRepositoryFactory.create);
}
