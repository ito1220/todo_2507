import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void toggleTodo(String id) {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(isDone: !_todos[index].isDone);
      notifyListeners();
    }
  }

  // 🔄 タスクを履歴つきで更新
  void updateTodoWithHistory({
    required String id,
    required String newTitle,
    required String newCategory,
    required DateTime? newDeadline,
    required int newImportance,
  }) {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) return;

    final old = _todos[index];

    final newHistory = TodoHistory(
      oldTitle: old.title,
      oldCategory: old.category,
      oldDeadline: old.deadline,
      updatedAt: DateTime.now(),
    );

    final updated = old.copyWith(
      title: newTitle,
      category: newCategory,
      deadline: newDeadline,
      importance: newImportance,
      history: [...old.history, newHistory],
    );

    _todos[index] = updated;
    notifyListeners();
  }

  // 📈 達成率を返す
  double getCompletionRate() {
    if (_todos.isEmpty) return 0;
    int completed = _todos.where((todo) => todo.isDone).length;
    return completed / _todos.length;
  }
}
