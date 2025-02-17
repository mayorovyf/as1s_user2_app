// lib/api/login_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class LoginApi {
  /// Отправляет запрос на логин по адресу POST /login_user2.
  /// При успешном входе возвращает api_key, иначе возвращает null.
  static Future<String?> loginUser(String username, String password) async {
    final response = await ApiService.postRequest('/login_user2', {
      "username": username,
      "password": password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['api_key'];
    } else {
      // Обработка ошибок (например, неверный формат запроса или неверный логин/пароль)
      return null;
    }
  }
}
