// lib/services/card_service.dart
import 'package:dio/dio.dart';
import '../model/card/card_dto.dart';
import 'api_client.dart';

class CardService {
  final Dio _dio = ApiClient().dio;

  Future<List<CardDto>> getCards(String listId) async {
    final response = await _dio.get('/cards/list/$listId');
    final List<dynamic> data = response.data;
    return data.map((json) => CardDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<CardDto> createCard(String listId, String title ,String description ,int priority ,String deadline ) async {
    final response = await _dio.post('/cards/', data: {
      'listId': listId,
      'title': title,
      'description': description,
      'priority': priority,
      'deadline': deadline,
    });
    return CardDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CardDto> updateCard(String cardId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put(
        '/cards/$cardId',
        data: updates,
      );
      return CardDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CardDto> updateCardModel(String cardId, String title, String description, int priority, String deadline) async {
    return updateCard(cardId, {
      'title': title,
      'description': description,
      'priority': priority,
      'deadline': deadline,
    });
  }

  Future<void> deleteCard(String cardId) async {
    try {
      await _dio.delete('/cards/$cardId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> moveCard(String cardId, String? newListId, int position) async {
    await _dio.put('/cards/$cardId/move', data: {
      if (newListId != null) 'listId': newListId,
      'position': position,
    });
  }

  Future<void> addComment(String cardId, String content) async {
    await _dio.post('/cards/$cardId/comments', data: {'content': content});
  }

  String _handleError(DioException e) {
    if (e.response?.statusCode == 404) {
      return 'List không tồn tại';
    }
    if (e.response?.statusCode == 403) {
      return 'Bạn không có quyền thực hiện thao tác này';
    }
    if (e.response?.statusCode == 400) {
      return 'Dữ liệu không hợp lệ';
    }

    final detail = e.response?.data is Map<String, dynamic>
        ? e.response?.data['detail']
        : e.message;
    return detail ?? 'Lỗi không xác định';
  }
}