import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  final String baseUrl = "http://10.0.2.2:5269/api";

  factory ApiService() => _instance;

  ApiService._internal() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _storage.read(key: "token");
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print("Lỗi API: ${e.response?.data ?? e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  Dio get send => _dio;
}
