import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../core/network/dio_client.dart';

class UserRemoteDataSource {
  final DioClient client;
  UserRemoteDataSource(this.client);

  Future<List<UserModel>> fetchUsers({int page = 1}) async {
    // Mock instead of hitting API
    return [
      UserModel(id: 1, email: "test1@mail.com", firstName: "John", lastName: "Doe", avatar: "https://i.pravatar.cc/150?img=1"),
      UserModel(id: 2, email: "test2@mail.com", firstName: "Jane", lastName: "Smith", avatar: "https://i.pravatar.cc/150?img=2"),
    ];
  }}