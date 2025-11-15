import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_tut/ui/auth_page.dart';

import '../../model/board/board_dto.dart';
import '../../services/api_client.dart';
import '../../services/board_service.dart';
import '../board_page.dart';

class HomePage extends StatefulWidget {
  String username;
  String? userId;
  HomePage({super.key, required this.username, this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BoardService _boardService = BoardService();
  List<BoardDto> _boards = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Màu sắc theme
  final Color primaryPurple = const Color(0xFF7C3AED);
  final Color lightPurple = const Color(0xFF9F7AEA);
  final Color darkPurple = const Color(0xFF5B21B6);

  @override
  void initState() {
    super.initState();
    _loadBoards();
  }

  Future<void> _loadBoards() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final boards = await _boardService.getBoards();
      setState(() {
        _boards = boards.cast<BoardDto>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createBoard(String title) async {
    try {
      final newBoard = await _boardService.createBoard(title);
      setState(() {
        _boards.add(newBoard);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Đã tạo board mới'),
            backgroundColor: primaryPurple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Lỗi: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _deleteBoard(BoardDto board) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.warning_amber_rounded,
                      color: Colors.orange.shade700),
                ),
                const SizedBox(width: 12),
                const Text('Xác nhận xóa',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text('Bạn có chắc chắn muốn xóa board "${board.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                    'Hủy', style: TextStyle(color: Colors.grey.shade600)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                    'Xóa', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await _boardService.deleteBoard(board.id);
        setState(() {
          _boards.remove(board);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Đã xóa board'),
              backgroundColor: primaryPurple,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Lỗi: $e'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    }
  }

  Future<void> _addMember(BoardDto board) async {
    final userIdController = TextEditingController();
    final roleController = TextEditingController(text: 'member');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightPurple.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person_add, color: primaryPurple),
                ),
                const SizedBox(width: 12),
                const Text('Thêm thành viên',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: userIdController,
                  decoration: InputDecoration(
                    labelText: 'User ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryPurple, width: 2),
                    ),
                    prefixIcon: Icon(Icons.person, color: primaryPurple),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(
                    labelText: 'Vai trò (member/admin)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryPurple, width: 2),
                    ),
                    prefixIcon: Icon(
                        Icons.admin_panel_settings, color: primaryPurple),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                    'Hủy', style: TextStyle(color: Colors.grey.shade600)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  elevation: 0,
                ),
                onPressed: () {
                  if (userIdController.text.isNotEmpty) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text(
                    'Thêm', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
    );

    if (result == true && userIdController.text.isNotEmpty) {
      try {
        final updatedBoard = await _boardService.addMember(
          board.id,
          userIdController.text,
          role: roleController.text.isEmpty ? 'member' : roleController.text,
        );
        setState(() {
          final index = _boards.indexWhere((b) => b.id == board.id);
          if (index != -1) {
            _boards[index] = updatedBoard;
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Đã thêm thành viên'),
              backgroundColor: primaryPurple,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Lỗi: $e'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    }
  }

  Future<void> _removeMember(BoardDto board) async {
    if (board.members == null || board.members!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Board chưa có thành viên nào'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final memberId = await showDialog<String>(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person_remove, color: Colors.red.shade700),
                ),
                const SizedBox(width: 12),
                const Text('Xóa thành viên',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Chọn thành viên cần xóa:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                ...board.members!.map((member) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: lightPurple.withValues(alpha:0.3),
                        child: Text(
                          member.toString().substring(0, 1).toUpperCase(),
                          style: TextStyle(
                              color: darkPurple, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(member.toString(), style: const TextStyle(
                          fontWeight: FontWeight.w500)),
                      trailing: Icon(Icons.chevron_right, color: primaryPurple),
                      onTap: () => Navigator.pop(context, member.toString()),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                    'Hủy', style: TextStyle(color: Colors.grey.shade600)),
              ),
            ],
          ),
    );

    if (memberId != null) {
      try {
        final updatedBoard = await _boardService.removeMember(
            board.id, memberId);
        setState(() {
          final index = _boards.indexWhere((b) => b.id == board.id);
          if (index != -1) {
            _boards[index] = updatedBoard;
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Đã xóa thành viên'),
              backgroundColor: primaryPurple,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Lỗi: $e'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    }
  }

  void _showCreateBoardDialog() {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lightPurple.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.dashboard, color: primaryPurple),
                ),
                const SizedBox(width: 12),
                const Text('Tạo Board Mới',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tên Board',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryPurple, width: 2),
                ),
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                    'Hủy', style: TextStyle(color: Colors.grey.shade600)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  elevation: 0,
                ),
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    _createBoard(titleController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                    'Tạo', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
    );
  }

  void _openBoard(BoardDto board) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardPage(board: board),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryPurple, darkPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Boards',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            Row(
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                if (widget.userId != null) ...[
                  const Text(
                    ' • ',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  SelectableText(
                    'ID: ${widget.userId}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _loadBoards,
            tooltip: 'Tải lại',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
            },
            tooltip: 'Thông báo',
          ),
          PopupMenuButton<String>(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 20, color: Color(0xFF7C3AED)),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: primaryPurple),
                    const SizedBox(width: 8),
                    const Text('Hồ sơ'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Cài đặt'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'logout') {
                await ApiClient().clearToken();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(builder: (context) => AuthPage()),
                  );
                }
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateBoardDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tạo Board',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: primaryPurple,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Đang tải boards...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                  Icons.error_outline, size: 64, color: Colors.red.shade400),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Lỗi: $_errorMessage',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadBoards,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                  'Thử lại', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ],
        ),
      );
    }

    if (_boards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: lightPurple.withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.dashboard_outlined,
                size: 80,
                color: lightPurple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chưa có board nào',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhấn nút "Tạo Board" để bắt đầu',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            lightPurple.withValues(alpha:0.05),
            Colors.purple.shade50.withValues(alpha:0.3),
          ],
        ),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _boards.length,
        itemBuilder: (context, index) {
          return _buildBoardCard(_boards[index]);
        },
      ),
    );
  }

  Widget _buildBoardCard(BoardDto board) {
    return Card(
      elevation: 3,
      shadowColor: primaryPurple.withValues(alpha:0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              lightPurple.withValues(alpha:0.05),
            ],
          ),
        ),
        child: InkWell(
          onTap: () => _openBoard(board),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryPurple, lightPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: primaryPurple.withValues(alpha:0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.dashboard_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        board.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                          Icons.more_vert_rounded, color: Colors.grey.shade600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) =>
                      [
                        PopupMenuItem(
                          value: 'add_member',
                          child: Row(
                            children: [
                              Icon(Icons.person_add, color: primaryPurple),
                              const SizedBox(width: 8),
                              const Text('Thêm thành viên'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'remove_member',
                          child: Row(
                            children: [
                              Icon(Icons.person_remove, color: Colors.orange),
                              SizedBox(width: 8),
                              Text('Xóa thành viên'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Xóa board',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteBoard(board);
                        } else if (value == 'add_member') {
                          _addMember(board);
                        } else if (value == 'remove_member') {
                          _removeMember(board);
                        }
                      },
                    ),
                  ],
                ),
                if (board.description != null &&
                    board.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    board.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: lightPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: lightPurple.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                          Icons.people_rounded, size: 18, color: primaryPurple),
                      const SizedBox(width: 6),
                      Text(
                        '${(board.members?.length ?? 0) + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryPurple,
                        ),
                      ),
                      const Spacer(),
                      if (board.createdAt != null)
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 14,
                                color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(board.createdAt!),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Hôm nay';
    } else if (diff.inDays == 1) {
      return 'Hôm qua';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ngày';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}