import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_tut/services/card_service.dart';
import 'package:instagram_tut/services/list_service.dart';
import '../../model/board/board_dto.dart';
import '../model/card/card_dto.dart';
import '../model/list/list_dto.dart';

class BoardPage extends StatefulWidget {
  final BoardDto board;

  const BoardPage({Key? key, required this.board}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final ListService _listService = ListService();
  final CardService _cardService = CardService();
  List<ListDto> _lists = [];
  final Map<String, List<CardDto>> _cardsMap = {};
  bool _isLoading = true;
  String? _errorMessage;

  // Purple theme colors
  static const primaryPurple = Color(0xFF7C3AED);
  static const darkPurple = Color(0xFF5B21B6);
  static const lightPurple = Color(0xFFF5F3FF);
  static const accentPurple = Color(0xFFA78BFA);

  @override
  void initState() {
    super.initState();
    _loadBoardData();
  }

  Future<void> _loadBoardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final lists = await _listService.getLists(widget.board.id);
      _lists = lists.cast<ListDto>();

      _cardsMap.clear();
      for (var list in _lists) {
        final cards = await _cardService.getCards(list.id);
        _cardsMap[list.id] = cards;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createList(String title) async {
    try {
      final newList = await _listService.createList(widget.board.id, title);
      setState(() {
        _lists.add(newList);
        _cardsMap[newList.id] = [];
      });
      if (mounted) {
        _showSuccessSnackBar('Đã tạo cột mới');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Lỗi: $e');
      }
    }
  }

  Future<void> _updateListTitle(String listId, String newTitle) async {
    try {
      final updatedList = await _listService.updateListTitle(listId, newTitle);
      setState(() {
        final index = _lists.indexWhere((list) => list.id == listId);
        if (index != -1) {
          _lists[index] = updatedList;
        }
      });
      if (mounted) {
        _showSuccessSnackBar('Đã cập nhật tên cột');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Lỗi: $e');
      }
    }
  }

  Future<void> _deleteList(String listId) async {
    try {
      await _listService.deleteList(listId);
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Lỗi: $e');
      }
    }
  }

  Future<void> _createCard(String cardId, String title, String description, int priority, String deadline) async {
    try {
      final newCard = await _cardService.createCard(cardId, title, description, priority, deadline);

      setState(() {
        _cardsMap.putIfAbsent(cardId, () => []).add(newCard);
      });

      if (mounted) {
        _showSuccessSnackBar('Đã tạo thẻ mới');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Lỗi: $e');
      }
    }
  }

  Future<void> _updateCard(String cardId, String listId, String title, String description, int priority, String deadline) async {
    try {
      final updatedCard = await _cardService.updateCardModel(cardId, title, description, priority, deadline);

      setState(() {
        final cards = _cardsMap[listId];
        if (cards != null) {
          final index = cards.indexWhere((c) => c.id == cardId);
          if (index != -1) {
            cards[index] = updatedCard;
          }
        }
      });

      if (mounted) {
        _showSuccessSnackBar('Đã cập nhật thẻ');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Lỗi: $e');
      }
    }
  }

  Future<void> _deleteCard(String cardId, String listId) async {
    try {
      await _cardService.deleteCard(cardId);
      setState(() {
        _cardsMap[listId]!.removeWhere((c) => c.id == cardId);
      });
      if (mounted) {
        _showSuccessSnackBar('Đã xóa thẻ');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Lỗi: $e');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showAddColumnDialog() {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, lightPurple.withValues(alpha:0.3)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryPurple.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.view_column, color: primaryPurple, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Thêm cột mới',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Tên cột',
                  hintText: 'Nhập tên cột...',
                  prefixIcon: const Icon(Icons.title, color: primaryPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: primaryPurple, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Hủy', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty) {
                        _createList(titleController.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                    child: const Text('Thêm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(String listId) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedPriority = 'Medium';
    DateTime? selectedDeadline;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          int priority = 1;
          switch (selectedPriority) {
            case 'High':
              priority = 0;
              break;
            case 'Medium':
              priority = 1;
              break;
            case 'Low':
              priority = 2;
              break;
            default:
              priority = 1;
          }

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 8,
            child: Container(
              width: 500,
              constraints: const BoxConstraints(maxHeight: 700),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, lightPurple.withValues(alpha:0.2)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: primaryPurple.withValues(alpha:0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryPurple,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: primaryPurple.withValues(alpha:0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add_task, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Tạo thẻ mới',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Field
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Tiêu đề *',
                              hintText: 'Nhập tiêu đề thẻ',
                              prefixIcon: const Icon(Icons.title, color: primaryPurple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: primaryPurple, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            autofocus: true,
                          ),
                          const SizedBox(height: 16),

                          // Description Field
                          TextField(
                            controller: descController,
                            decoration: InputDecoration(
                              labelText: 'Mô tả (tùy chọn)',
                              hintText: 'Thêm mô tả chi tiết...',
                              prefixIcon: const Icon(Icons.description_outlined, color: primaryPurple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: primaryPurple, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),

                          // Priority Dropdown
                          DropdownButtonFormField<String>(
                            value: selectedPriority,
                            decoration: InputDecoration(
                              labelText: 'Độ ưu tiên',
                              prefixIcon: Icon(
                                Icons.flag,
                                color: selectedPriority == 'High'
                                    ? Colors.red
                                    : selectedPriority == 'Medium'
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: primaryPurple, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: [
                              _buildPriorityMenuItem('High', Colors.red, 'Cao'),
                              _buildPriorityMenuItem('Medium', Colors.orange, 'Trung bình'),
                              _buildPriorityMenuItem('Low', Colors.green, 'Thấp'),
                            ],
                            onChanged: (value) {
                              setDialogState(() {
                                selectedPriority = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Deadline Picker
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDeadline ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: primaryPurple,
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (picked != null) {
                                setDialogState(() {
                                  selectedDeadline = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                  );
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey.shade50,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: selectedDeadline != null ? primaryPurple : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hạn chót (tùy chọn)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          selectedDeadline != null
                                              ? _formatDeadline(selectedDeadline!)
                                              : 'Chọn ngày hạn chót',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: selectedDeadline != null
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: selectedDeadline != null
                                                ? Colors.black87
                                                : Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selectedDeadline != null)
                                    IconButton(
                                      icon: const Icon(Icons.clear, size: 20),
                                      onPressed: () {
                                        setDialogState(() {
                                          selectedDeadline = null;
                                        });
                                      },
                                      color: Colors.grey.shade600,
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // Deadline warning
                          if (selectedDeadline != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _getDeadlineWarningColor(selectedDeadline!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getDeadlineIcon(selectedDeadline!),
                                    size: 18,
                                    color: _getDeadlineTextColor(selectedDeadline!),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _getDeadlineWarning(selectedDeadline!),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: _getDeadlineTextColor(selectedDeadline!),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Hủy', style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Thêm thẻ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          onPressed: () {
                            if (titleController.text.trim().isNotEmpty) {
                              _createCard(
                                listId,
                                titleController.text.trim(),
                                descController.text.trim(),
                                priority,
                                selectedDeadline.toString(),
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  DropdownMenuItem<String> _buildPriorityMenuItem(String value, Color color, String label) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text('$label ($value)'),
        ],
      ),
    );
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    final dateStr = '${deadline.day}/${deadline.month}/${deadline.year}';

    if (difference.inDays == 0) {
      return 'Hôm nay - $dateStr';
    } else if (difference.inDays == 1) {
      return 'Ngày mai - $dateStr';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày nữa - $dateStr';
    }

    return dateStr;
  }

  Color _getDeadlineWarningColor(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays < 1) {
      return Colors.red.shade50;
    } else if (difference.inDays < 3) {
      return Colors.orange.shade50;
    }
    return primaryPurple.withValues(alpha:0.1);
  }

  Color _getDeadlineTextColor(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays < 1) {
      return Colors.red.shade700;
    } else if (difference.inDays < 3) {
      return Colors.orange.shade700;
    }
    return primaryPurple;
  }

  IconData _getDeadlineIcon(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays < 1) {
      return Icons.warning_amber_rounded;
    } else if (difference.inDays < 3) {
      return Icons.access_time;
    }
    return Icons.schedule;
  }

  String _getDeadlineWarning(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays < 1) {
      return 'Hạn chót hôm nay!';
    } else if (difference.inDays < 3) {
      return 'Còn ${difference.inDays} ngày để hoàn thành';
    }
    return 'Hạn chót: ${_formatDeadline(deadline)}';
  }

  void _showTaskDetail(CardDto card, String listId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 550,
          constraints: const BoxConstraints(maxHeight: 700),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, lightPurple.withValues(alpha:0.2)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryPurple.withValues(alpha:0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        card.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildPriorityChip(card.priority ?? 0),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (card.description != null && card.description!.isNotEmpty) ...[
                        _buildSectionTitle('Mô tả'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(card.description!, style: const TextStyle(fontSize: 15)),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (card.deadline != null) ...[
                        _buildSectionTitle('Hạn chót'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${card.deadline!.day}/${card.deadline!.month}/${card.deadline!.year}',
                                style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (card.attachments.isNotEmpty) ...[
                        _buildSectionTitle('Tệp đính kèm (${card.attachments.length})'),
                        const SizedBox(height: 8),
                        ...card.attachments.map((att) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.attachment, size: 18, color: primaryPurple),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(att.name, style: const TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 16),
                      ],
                      if (card.comments.isNotEmpty) ...[
                        _buildSectionTitle('Bình luận (${card.comments.length})'),
                        const SizedBox(height: 8),
                        ...card.comments.map((c) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('• ${c.content}', style: const TextStyle(fontSize: 14)),
                        )),
                        const SizedBox(height: 16),
                      ],
                      _buildSectionTitle('Hành động'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildActionButton(
                            icon: Icons.edit,
                            label: 'Chỉnh sửa',
                            color: primaryPurple,
                            onPressed: () {
                              Navigator.pop(context);
                              _showEditTaskDialog(card, listId);
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.delete,
                            label: 'Xóa thẻ',
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                              _confirmDeleteCard(card.id, listId);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Đóng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: primaryPurple,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha:0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  Widget _buildPriorityChip(int? priority) {
    String label;
    Color color;
    IconData icon;

    switch (priority) {
      case 0:
        label = 'Cao';
        color = Colors.red;
        icon = Icons.arrow_upward;
        break;
      case 2:
        label = 'Thấp';
        color = Colors.green;
        icon = Icons.arrow_downward;
        break;
      default:
        label = 'Trung bình';
        color = Colors.orange;
        icon = Icons.remove;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Color _getListColor(int index) {
    final colors = [
      const Color(0xFFFFEBEE),
      const Color(0xFFFFF9C4),
      const Color(0xFFE8F5E9),
      const Color(0xFFE3F2FD),
      lightPurple,
      const Color(0xFFFFF3E0),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [lightPurple, Colors.white],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: primaryPurple),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [lightPurple, Colors.white],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadBoardData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        title: Text(widget.board.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Tìm kiếm',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
            tooltip: 'Lọc',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryPurple.withValues(alpha:0.1), lightPurple.withValues(alpha:0.3)],
          ),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          itemCount: _lists.length + 1,
          itemBuilder: (context, index) {
            if (index == _lists.length) {
              return _buildAddColumnButton();
            }
            final list = _lists[index];
            final cards = _cardsMap[list.id] ?? [];
            return _buildColumn(list, cards);
          },
        ),
      ),
    );
  }

  Widget _buildColumn(ListDto list, List<CardDto> cards) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getListColor(_lists.indexOf(list)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${list.title} (${cards.length})',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha:0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: PopupMenuButton(
                      icon: const Icon(Icons.more_horiz, size: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'rename',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: primaryPurple),
                              SizedBox(width: 8),
                              Text('Đổi tên'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Xóa cột', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteListDialog(list);
                        } else if (value == 'rename') {
                          _showRenameListDialog(list);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cards.length + 1,
                  itemBuilder: (context, index) {
                    if (index == cards.length) {
                      return _buildAddTaskButton(list.id);
                    }
                    return _buildTaskCard(cards[index], list.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteListDialog(ListDto list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('Xác nhận xóa'),
          ],
        ),
        content: Text('Bạn có chắc chắn muốn xóa cột "${list.title}"?\nTất cả thẻ trong cột này sẽ bị xóa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                _lists.remove(list);
                _cardsMap.remove(list.id);
              });
              _deleteList(list.id);
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showRenameListDialog(ListDto list) {
    final titleController = TextEditingController(text: list.title);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryPurple.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit, color: primaryPurple, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Text('Đổi tên cột', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Tên cột',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: primaryPurple, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Hủy'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty) {
                        _updateListTitle(list.id, titleController.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cập nhật', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(CardDto card, String listId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showTaskDetail(card, listId),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      card.title,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                  _buildPriorityChip(card.priority),
                ],
              ),
              if (card.description != null && card.description!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  card.description!,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildCardInfo(
                    Icons.calendar_today,
                    card.deadline != null ? '${card.deadline!.day}/${card.deadline!.month}' : 'Không có hạn',
                  ),
                  const Spacer(),
                  _buildCardInfo(Icons.comment_outlined, '${card.comments.length}'),
                  const SizedBox(width: 12),
                  _buildCardInfo(Icons.attachment, '${card.attachments.length}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: primaryPurple.withValues(alpha:0.7)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildAddTaskButton(String listId) {
    return InkWell(
      onTap: () => _showAddTaskDialog(listId),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: primaryPurple.withValues(alpha:0.3), width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: primaryPurple),
            const SizedBox(width: 8),
            Text(
              'Thêm thẻ',
              style: TextStyle(color: primaryPurple, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(CardDto card, String listId) {
    final titleCtrl = TextEditingController(text: card.title);
    final descCtrl = TextEditingController(text: card.description ?? '');
    String selectedPriority = _priorityIntToString(card.priority ?? 1);
    DateTime? selectedDeadline = card.deadline;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialog) {
          int priority = _priorityStringToInt(selectedPriority);

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              width: 500,
              constraints: const BoxConstraints(maxHeight: 700),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, lightPurple.withValues(alpha:0.2)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: primaryPurple.withValues(alpha:0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryPurple,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Text('Chỉnh sửa thẻ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextField(
                            controller: titleCtrl,
                            decoration: InputDecoration(
                              labelText: 'Tiêu đề *',
                              prefixIcon: const Icon(Icons.title, color: primaryPurple),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: primaryPurple, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: descCtrl,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Mô tả (tùy chọn)',
                              prefixIcon: const Icon(Icons.description_outlined, color: primaryPurple),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: primaryPurple, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedPriority,
                            decoration: InputDecoration(
                              labelText: 'Độ ưu tiên',
                              prefixIcon: Icon(Icons.flag,
                                  color: selectedPriority == 'High'
                                      ? Colors.red
                                      : selectedPriority == 'Medium'
                                      ? Colors.orange
                                      : Colors.green),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: primaryPurple, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: [
                              _buildPriorityMenuItem('High', Colors.red, 'Cao'),
                              _buildPriorityMenuItem('Medium', Colors.orange, 'Trung bình'),
                              _buildPriorityMenuItem('Low', Colors.green, 'Thấp'),
                            ],
                            onChanged: (v) => setDialog(() => selectedPriority = v!),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: selectedDeadline ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: primaryPurple,
                                        onPrimary: Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setDialog(() => selectedDeadline = DateTime(picked.year, picked.month, picked.day));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey.shade50,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: selectedDeadline != null ? primaryPurple : Colors.grey.shade600),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      selectedDeadline != null
                                          ? _formatDeadline(selectedDeadline!)
                                          : 'Chọn ngày hạn chót',
                                      style: TextStyle(
                                        fontWeight: selectedDeadline != null ? FontWeight.bold : FontWeight.normal,
                                        color: selectedDeadline != null ? Colors.black87 : Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  if (selectedDeadline != null)
                                    IconButton(
                                      icon: const Icon(Icons.clear, size: 20),
                                      onPressed: () => setDialog(() => selectedDeadline = null),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Footer
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: const Text('Hủy'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.save),
                          label: const Text('Lưu', style: TextStyle(fontWeight: FontWeight.w600)),
                          onPressed: () {
                            if (titleCtrl.text.trim().isEmpty) return;
                            _updateCard(
                              card.id,
                              listId,
                              titleCtrl.text.trim(),
                              descCtrl.text.trim(),
                              priority,
                              selectedDeadline?.toString() ?? '',
                            );
                            Navigator.pop(ctx);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _priorityIntToString(int p) {
    switch (p) {
      case 0:
        return 'High';
      case 2:
        return 'Low';
      default:
        return 'Medium';
    }
  }

  int _priorityStringToInt(String s) {
    switch (s) {
      case 'High':
        return 0;
      case 'Low':
        return 2;
      default:
        return 1;
    }
  }

  Widget _buildAddColumnButton() {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shadowColor: primaryPurple.withValues(alpha:0.2),
        color: Colors.white.withValues(alpha:0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: _showAddColumnDialog,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryPurple.withValues(alpha:0.2), width: 2),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, lightPurple.withValues(alpha:0.3)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryPurple.withValues(alpha:0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, size: 40, color: primaryPurple),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Thêm cột mới',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteCard(String cardId, String listId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('Xác nhận xóa'),
          ],
        ),
        content: const Text('Bạn có chắc chắn muốn xóa thẻ này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              _deleteCard(cardId, listId);
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String? _formatDateForApi(DateTime? date) {
    if (date == null) return null;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}