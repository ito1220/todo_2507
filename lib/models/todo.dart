import 'package:flutter/material.dart';
import 'dart:convert'; // ★ JSON変換用
import 'todo_history.dart';

class Todo {
  String id;
  String title;
  String category;
  DateTime? deadline;
  bool isDone;
  int importance; // ★1〜3 の重要度
  List<TodoHistory> history; // ← 履歴を保存するリスト

   String memo;

  Todo({
    required this.id,
    required this.title,
    required this.category,
    this.deadline,
    this.isDone = false,
    this.importance = 1,
    this.history = const [],
    this.memo = '',
  });

  Todo copyWith({
    String? id,
    String? title,
    String? category,
    DateTime? deadline,
    bool? isDone,
    int? importance,
    List<TodoHistory>? history,
    String? memo
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      deadline: deadline ?? this.deadline,
      isDone: isDone ?? this.isDone,
      importance: importance ?? this.importance,
      history: history ?? this.history,
      memo: memo ?? this.memo,
    );
  }

  // ✅ JSON変換用：Map化
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'deadline': deadline?.toIso8601String(),
      'isDone': isDone,
      'importance': importance,
      'history': history.map((h) => h.toJson()).toList(),
      'memo': memo,
    };
  }

  // ✅ JSONからTodoインスタンスへ
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      isDone: json['isDone'] ?? false,
      importance: json['importance'] ?? 1,
      history: json['history'] != null
          ? (json['history'] as List).map((h) => TodoHistory.fromJson(h)).toList()
          : [],
      memo: json['memo'] ?? '',
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

  // ✅ JSON変換用
  Map<String, dynamic> toJson() {
    return {
      'oldTitle': oldTitle,
      'oldCategory': oldCategory,
      'oldDeadline': oldDeadline?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // ✅ JSONからインスタンスに戻す
  factory TodoHistory.fromJson(Map<String, dynamic> json) {
    return TodoHistory(
      oldTitle: json['oldTitle'],
      oldCategory: json['oldCategory'],
      oldDeadline: json['oldDeadline'] != null ? DateTime.parse(json['oldDeadline']) : null,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
