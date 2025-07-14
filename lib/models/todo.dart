import 'package:flutter/material.dart';

class Todo {
  String id;
  String title;
  String category;
  DateTime? deadline;
  bool isDone;
  int importance; // ★1〜3 の重要度
  List<TodoHistory> history; // ← 履歴を保存するリスト

  Todo({
    required this.id,
    required this.title,
    required this.category,
    this.deadline,
    this.isDone = false,
    this.importance = 1,
    this.history = const [],
  });

  Todo copyWith({
    String? id,
    String? title,
    String? category,
    DateTime? deadline,
    bool? isDone,
    int? importance,
    List<TodoHistory>? history,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      deadline: deadline ?? this.deadline,
      isDone: isDone ?? this.isDone,
      importance: importance ?? this.importance,
      history: history ?? this.history,
    );
  }
}

// 🔁 更新履歴クラス
class TodoHistory {
  final String oldTitle;
  final String oldCategory;
  final DateTime? oldDeadline;
  final DateTime updatedAt;

  TodoHistory({
    required this.oldTitle,
    required this.oldCategory,
    required this.oldDeadline,
    required this.updatedAt,
  });
}
