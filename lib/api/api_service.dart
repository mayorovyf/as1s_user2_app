// lib/api/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class ApiService {
  // Общий метод для POST запросов
  static Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body) {
    final url = Uri.parse('${Config.serverIp}$endpoint');
    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }

  // Общий метод для GET запросов
  static Future<http.Response> getRequest(String endpoint, Map<String, String> queryParams) {
    final uri = Uri.parse('${Config.serverIp}$endpoint').replace(queryParameters: queryParams);
    return http.get(uri);
  }
}
