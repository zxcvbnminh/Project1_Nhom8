// lib/services/auth_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_client.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      final data = response.data;
      await ApiClient().saveToken(data['access_token']);
      return data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'userName': username, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> getId() async {
    try {
      final response = await _dio.get(
        '/auth/getId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await ApiClient().getToken()}',
          },
        ),
      );

      // Trả về user_id từ API
      return response.data['user_id'];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['detail'] ?? 'Lỗi không xác định';
    }
    return 'Không kết nối được server';
  }

}