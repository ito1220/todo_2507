import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_tile.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  String _selectedCategory = '勉強';
  DateTime? _selectedDate;
  int _selectedImportance = 1;

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('タスクを追加'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'タイトル'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: ['勉強', '生活', 'その他'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                  decoration: const InputDecoration(labelText: 'カテゴリ'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('締切: '),
                    Text(_selectedDate != null
                        ? _selectedDate!.toLocal().toString().split(' ')[0]
                        : '未設定'),
                    TextButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: const Text('選択'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('重要度: '),
                    DropdownButton<int>(
                      value: _selectedImportance,
                      items: [1, 2, 3].map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text('★' * level),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedImportance = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _titleController.clear();
                _selectedDate = null;
              },
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isEmpty) return;
                final newTodo = Todo(
                  id: DateTime.now().toIso8601String(),
                  title: _titleController.text.trim(),
                  category: _selectedCategory,
                  deadline: _selectedDate,
                  isDone: false,
                  importance: _selectedImportance,
                  history: [],
                );
                Provider.of<TodoProvider>(context, listen: false).addTodo(newTodo);
                Navigator.of(context).pop();
                _titleController.clear();
                _selectedDate = null;
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(BuildContext context, Todo todo) {
    final TextEditingController _editTitleController =
        TextEditingController(text: todo.title);
    final TextEditingController _editMemoController =
      TextEditingController(text: todo.memo);

    String _editCategory = todo.category;
    DateTime? _editDeadline = todo.deadline;
    int _editImportance = todo.importance;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('タスクを編集'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _editTitleController,
                      decoration: const InputDecoration(labelText: 'タイトル'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _editCategory,
                      items: ['勉強', '生活', 'その他'].map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _editCategory = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'カテゴリ'),
                    ),

                    const SizedBox(height: 10),
                    TextField(
                      controller: _editMemoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'メモ',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('締切: '),
                        Text(_editDeadline != null
                            ? _editDeadline!.toLocal().toString().split(' ')[0]
                            : '未設定'),
                        TextButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _editDeadline ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                _editDeadline = picked;
                              });
                            }
                          },
                          child: const Text('選択'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('重要度: '),
                        DropdownButton<int>(
                          value: _editImportance,
                          items: [1, 2, 3].map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text('★' * level),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _editImportance = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('キャンセル'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_editTitleController.text.trim().isEmpty) return;

                    Provider.of<TodoProvider>(context, listen: false)
                        .updateTodoWithHistory(
                      id: todo.id,
                      newTitle: _editTitleController.text.trim(),
                      newCategory: _editCategory,
                      newDeadline: _editDeadline,
                      newImportance: _editImportance,
                      newMemo: _editMemoController.text.trim(),
                    );

                    Navigator.of(context).pop();
                  },
                  child: const Text('保存'),
                ),
              ],
            );
          },
        );
      },
    );
  }

    // ✅ 追加：メモ表示用ダイアログ
  void _showMemoDialog(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('メモ'),
        content: Text(todo.memo.isNotEmpty ? todo.memo : 'メモはありません'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  final todoProvider = Provider.of<TodoProvider>(context);
  final themeProvider = Provider.of<ThemeProvider>(context); // ← 追加
  final todos = todoProvider.filteredTodos;

  return Scaffold(
    backgroundColor: themeProvider.backgroundColor, // ← 背景色を反映
    appBar: AppBar(
      title: const Text('タスク一覧'),
      centerTitle: true,
      leading: PopupMenuButton<Color>(
        icon: const Icon(Icons.color_lens),
        onSelected: (color) {
          themeProvider.changeBackgroundColor(color);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: ThemeProvider.pastelWhite,
             child: Text('ホワイト'),
          ),
          const PopupMenuItem(
            value: ThemeProvider.pastelBlue,
            child: Text('ブルー'),
           ),
          const  PopupMenuItem(
            value: ThemeProvider.pastelGreen,
            child: Text('グリーン'),
          ),
          const PopupMenuItem(
            value: ThemeProvider.pastelYellow,
            child: Text('イエロー'),
          ),
          const PopupMenuItem(
            value: ThemeProvider.pastelGrey,
            child: Text('グレー'),
          ),
          const PopupMenuItem(
            value: ThemeProvider.pastelPink, // ← ピンクを追加
            child: Text('パステルピンク'),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<SortOption>(
          icon: const Icon(Icons.sort), // 並び替えアイコン
          onSelected: (option) {
            Provider.of<TodoProvider>(context, listen: false)
                .updateSortOption(option);
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: SortOption.byCreated,
              child: Text('作成順'),
            ),
            PopupMenuItem(
              value: SortOption.byImportance,
              child: Text('重要度'),
            ),
            PopupMenuItem(
              value: SortOption.byDeadline,
              child: Text('締切日'),
            ),
          ],
        ),
      ],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: '検索（タイトル or カテゴリ）',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              Provider.of<TodoProvider>(context, listen: false)
                  .updateSearchKeyword(value);
            },
          ),
        ),

        // 🔽 並び替えメニュー ←★ここに入れる！
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          const Text('並び替え:'),
          const SizedBox(width: 10),
          DropdownButton<SortOption>(
            value: todoProvider.sortOption,
            onChanged: (SortOption? newValue) {
              if (newValue != null) {
                Provider.of<TodoProvider>(context, listen: false)
                    .updateSortOption(newValue);
              }
            },
            items: const [
              DropdownMenuItem(
                value: SortOption.byCreated,
                child: Text('作成順'),
              ),
              DropdownMenuItem(
                value: SortOption.byImportance,
                child: Text('重要度'),
              ),
              DropdownMenuItem(
                value: SortOption.byDeadline,
                child: Text('締切日'),
              ),
            ],
          ),
        ],
      ),
    ),

        Expanded(
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoTile(
                todo: todo,
                onToggle: () => todoProvider.toggleTodo(todo.id),
                onDelete: () => todoProvider.removeTodo(todo.id),
                onEdit: () {
                  _showEditTodoDialog(context, todo);
                },
                onViewMemo: () {
                 _showMemoDialog(context, todo); // ← ここでメモ表示ダイアログを呼ぶ
                },
              );
            },
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

