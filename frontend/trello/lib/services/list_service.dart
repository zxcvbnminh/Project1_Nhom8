import 'package:dio/dio.dart';
import 'package:instagram_tut/model/list/list_dto.dart';
import 'api_client.dart';

class ListService {
  final Dio _dio = ApiClient().dio;

  Future<List<ListDto>> getLists(String boardId) async {
    try {
      final response = await _dio.get('/lists/board/$boardId');
      final List<dynamic> data = response.data;
      return data.map((json) => ListDto.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ListDto> createList(String boardId, String title) async {
    try {
      final response = await _dio.post(
        '/lists/',
        data: {
          'boardId': boardId,
          'title': title,
        },
      );
      return ListDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ListDto> getListById(String listId) async {
    try {
      final response = await _dio.get('/lists/$listId');
      return ListDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<ListDto> updateList(String listId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put(
        '/lists/$listId',
        data: updates,
      );
      return ListDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  Future<ListDto> updateListTitle(String listId, String newTitle) async {
    return updateList(listId, {'title': newTitle});
  }


  Future<ListDto> updateListPosition(String listId, int newPosition) async {
    return updateList(listId, {'position': newPosition});
  }


  Future<void> deleteList(String listId) async {
    try {
      await _dio.delete('/lists/$listId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
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