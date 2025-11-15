import 'package:dio/dio.dart';
import 'package:instagram_tut/model/board/board_dto.dart';
import 'api_client.dart';

class BoardService {
  final Dio _dio = ApiClient().dio;

  /// 🟢 Lấy danh sách tất cả các board của người dùng
  Future<List<BoardDto>> getBoards() async {
    try {
      final response = await _dio.get('/boards');
      final List<dynamic> data = response.data;
      return data.map((json) => BoardDto.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 🟢 Tạo board mới
  Future<BoardDto> createBoard(String title) async {
    try {
      final response = await _dio.post(
        '/boards',
        data: {
          'title': title,
          'members': [],
        },
      );
      return BoardDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 🟢 Lấy thông tin 1 board cụ thể
  Future<BoardDto> getBoardById(String id) async {
    try {
      final response = await _dio.get('/boards/$id');
      return BoardDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 🟢 Cập nhật board
  Future<BoardDto> updateBoard(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put('/boards/$id', data: updates);
      return BoardDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 🔴 Xoá board
  Future<void> deleteBoard(String id) async {
    try {
      await _dio.delete('/boards/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 🟢 Thêm thành viên vào board
  Future<BoardDto> addMember(String boardId, String userId, {String role = 'member'}) async {
    try {
      final response = await _dio.post(
        '/boards/$boardId/members',
        data: {
          'userId': userId,
          'role': role,
        },
      );
      return BoardDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 🔴 Xoá thành viên khỏi board
  Future<BoardDto> removeMember(String boardId, String memberId) async {
    try {
      final response = await _dio.delete('/boards/$boardId/members/$memberId');
      return BoardDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// ⚙️ Hàm xử lý lỗi chung
  String _handleError(DioException e) {
    final detail = e.response?.data is Map<String, dynamic>
        ? e.response?.data['detail']
        : e.message;
    return detail ?? 'Lỗi không xác định';
  }
}
