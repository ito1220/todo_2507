// todo_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

// 並び替え方法を定義
enum SortOption {
  byCreated,
  byImportance,
  byDeadline,
}

//UI にデータ変更を通知
class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  SortOption _sortOption = SortOption.byCreated; // 🔸 並び替えの初期状態
  String _searchKeyword = ''; // 🔍 検索キーワード

  List<Todo> get todos => _todos;
  SortOption get sortOption => _sortOption;
  String get searchKeyword => _searchKeyword;

  List<Todo> get filteredTodos {
    List<Todo> filtered = [..._todos];

    if (_searchKeyword.isNotEmpty) {
      filtered = filtered.where((todo) =>
        todo.title.contains(_searchKeyword) ||
        todo.category.contains(_searchKeyword)
      ).toList();
    }

    switch (_sortOption) {
      case SortOption.byImportance:
        filtered.sort((a, b) => b.importance.compareTo(a.importance));
        break;
      case SortOption.byDeadline:
        filtered.sort((a, b) {
          if (a.deadline == null) return 1;
          if (b.deadline == null) return -1;
          return a.deadline!.compareTo(b.deadline!);
        });
        break;
      case SortOption.byCreated:
        break;
    }

    return filtered;
  }

  void updateSortOption(SortOption option) {
    _sortOption = option;
    _saveSortOption(); //保存処理
    notifyListeners();
  }

  void updateSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  TodoProvider() {
    _loadTodos(); // ローカルに保存されたタスクデータを読み込み
    _loadSortOption();
  }

  void addTodo(Todo todo) {
    _todos.add(todo); //タスクの追加
    _saveTodos(); //保存
    notifyListeners(); //UIに更新を通知
  }

 //指定された ID のタスクを削除
  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    _saveTodos();
    notifyListeners();
  }

  void toggleTodo(String id) {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(isDone: !_todos[index].isDone);
      _saveTodos();
      notifyListeners();
    }
  }

 //履歴管理・書き換え
  void updateTodoWithHistory({
    required String id,
    required String newTitle,
    required String newCategory,
    String? newMemo,
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
      memo: newMemo ?? old.memo,
      deadline: newDeadline,
      importance: newImportance,
      history: [...old.history, newHistory],
    );

    _todos[index] = updated;
    _saveTodos();
    notifyListeners();
  }

  List<TodoHistory> getTodoHistory(String id) {
    final todo = _todos.firstWhere(
      (todo) => todo.id == id,
      orElse: () => Todo(id: '', title: '', category: '', history: []),
    );
    return todo.history;
  }


  // ✅ データを保存（shared_preferences）
  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _todos.map((todo) => json.encode(todo.toJson())).toList();
    await prefs.setStringList('todos', jsonList);
  }

  // ✅ データを読み込み（shared_preferences）
  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('todos') ?? [];
    _todos = jsonList.map((jsonStr) => Todo.fromJson(json.decode(jsonStr))).toList();
    notifyListeners();
  }

  Future<void> _saveSortOption() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('sortOption', _sortOption.index); // enum を int で保存
  }

  Future<void> _loadSortOption() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('sortOption');
    if (index != null && index >= 0 && index < SortOption.values.length) {
      _sortOption = SortOption.values[index];
  }
}
}
