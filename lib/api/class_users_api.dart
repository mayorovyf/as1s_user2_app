// lib/api/class_users_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ClassUsersApi {
  /// Отправляет запрос для получения списка учеников по id класса пользователя 2.
  /// Тело запроса содержит API ключ пользователя 2.
  /// В ответе ожидается JSON с полями: status, users и timestamp.
  static Future<Map<String, dynamic>?> getClassUsers(String apiKey) async {
    final response = await ApiService.postRequest('/get_class_users', {
      "api_key": apiKey,
    });

    // Если статус 200 (OK), парсим ответ как успешный.
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // При ошибке пытаемся декодировать ответ и вернуть его содержимое.
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        return {
          "status": false,
          "error": "Ошибка при получении данных: ${response.statusCode}",
          "timestamp": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        };
      }
    }
  }
}
