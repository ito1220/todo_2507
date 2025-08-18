// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/todo_provider.dart';
// import '../models/todo.dart';

// class HistoryScreen extends StatelessWidget {
//   final String todoId;

//   const HistoryScreen({Key? key, required this.todoId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final todoProvider = Provider.of<TodoProvider>(context);
//     final List<TodoHistory> histories = todoProvider.getTodoHistory(todoId);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('更新履歴'),
//       ),
//       body: histories.isEmpty
//           ? const Center(child: Text('履歴がありません'))
//           : ListView.builder(
//               itemCount: histories.length,
//               itemBuilder: (context, index) {
//                 final history = histories[index];
//                 return ListTile(
//                   leading: const Icon(Icons.history),
//                   title: Text('タイトル: ${history.oldTitle}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('カテゴリ: ${history.oldCategory}'),
//                       Text('締切: ${history.oldDeadline != null ? history.oldDeadline!.toLocal().toString().split(' ')[0] : '未設定'}'),
//                       Text('更新日時: ${history.updatedAt.toLocal().toString().split('.')[0]}'),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
