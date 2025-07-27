class TodoHistory {
  final String todoId;
  final DateTime editedAt;
  final String oldTitle;
  final String oldCategory;
  final DateTime? oldDeadline;

  TodoHistory({
    required this.todoId,
    required this.editedAt,
    required this.oldTitle,
    required this.oldCategory,
    this.oldDeadline,
  });
}