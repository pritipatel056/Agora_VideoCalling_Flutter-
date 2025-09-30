import 'package:dio/dio.dart';

import '../constants.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: Duration(seconds: 5000), // 5 seconds
      receiveTimeout: Duration(seconds: 50000),));
  }
}