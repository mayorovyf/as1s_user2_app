// lib/api/user_data_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class UserDataApi {
  /// Получает данные пользователя по GET /user2_data?api_key=...
  /// При успешном запросе возвращает Map с данными пользователя.
  static Future<Map<String, dynamic>?> fetchUserData(String apiKey) async {
    final response = await ApiService.getRequest('/user2_data', {
      "api_key": apiKey,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      // Обработка ошибок (например, отсутствует API ключ или пользователь не найден)
      return null;
    }
  }
}
