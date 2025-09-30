import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserLocalDataSource {
  final Box box;
  UserLocalDataSource(this.box);

  Future<void> cacheUsers(List<UserModel> users) async {
    final jsonList = users.map((u) => u.toJson()).toList();
    await box.put('users', jsonList);
  }

  List<UserModel> getCachedUsers() {
    final data = box.get('users');
    if (data == null) return [];
    return (data as List<dynamic>).map((e) => UserModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}