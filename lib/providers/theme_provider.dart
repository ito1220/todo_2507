import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // パステルカラーの背景色リスト例
  static const pastelWhite = Color(0xFFFFFBF0);
  static const pastelBlue = Color(0xFFAEDFF7);
  static const pastelGreen = Color(0xFFB9E4C9);
  static const pastelYellow = Color(0xFFFFF9C4);
  static const pastelGrey = Color(0xFFD7D7D7);
  static const pastelPink = Color(0xFFF9C5D1);

  Color _backgroundColor = pastelWhite;

  Color get backgroundColor => _backgroundColor;

  Future<void> changeBackgroundColor(Color color) async {
    _backgroundColor = color;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('backgroundColor', color.value); // 保存
  }

 Future<void> loadBackgroundColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('backgroundColor');

    if (colorValue != null) {
      _backgroundColor = Color(colorValue);
      notifyListeners(); // 読み込んだ後にUI更新
    }
  }  
}
