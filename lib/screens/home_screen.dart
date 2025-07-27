import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_tile.dart';
import 'history_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todos = todoProvider.todos;
    final completionRate = todoProvider.completionRate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('タスク一覧'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '達成率： ${(completionRate * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: completionRate,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
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
                  onViewHistory: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HistoryScreen(todoId: todo.id),
                      ),
                    );
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
