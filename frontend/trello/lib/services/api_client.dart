// lib/services/api_client.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;

  // Khởi tạo Dio với base config
  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:8000', // Thay bằng domain khi deploy
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Thêm Interceptor: tự động thêm token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('REQUEST: ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE: ${response.statusCode} ${response.data}');
        handler.next(response);
      },
      onError: (DioException e, handler) {
        print('ERROR: ${e.response?.statusCode} ${e.message}');
        handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;

  // Lưu token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // Lấy token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
  // Xóa token (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}