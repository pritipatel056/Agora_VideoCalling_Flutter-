import '../datasources/user_remote_datasource.dart';
import '../datasources/user_local_datasource.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;

  UserRepository({required this.remote, required this.local});

  Future<List<UserModel>> getUsers({int page = 1}) async {
    try {
      final users = await remote.fetchUsers(page: page);
      await local.cacheUsers(users);
      return users;
    } catch (e) {
// fallback to cache
      final cached = local.getCachedUsers();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }
}