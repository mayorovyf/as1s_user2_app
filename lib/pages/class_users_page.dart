// lib/pages/class_users_page.dart
import 'package:flutter/material.dart';
import '../api/class_users_api.dart';
import '../services/shared_prefs_service.dart';

class ClassUsersPage extends StatefulWidget {
  const ClassUsersPage({Key? key}) : super(key: key);

  @override
  ClassUsersPageState createState() => ClassUsersPageState();
}

class ClassUsersPageState extends State<ClassUsersPage> {
  bool isLoading = false;
  String? errorMessage;
  List<dynamic> users = [];
  int? timestamp; // текущая метка времени, полученная от сервера

  @override
  void initState() {
    super.initState();
    _loadClassUsers();
  }

  Future<void> _loadClassUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final apiKey = await SharedPrefsService.getApiKey();
    if (apiKey == null) {
      setState(() {
        errorMessage = "Пользователь не авторизован.";
        isLoading = false;
      });
      return;
    }

    final response = await ClassUsersApi.getClassUsers(apiKey);
    if (response == null) {
      setState(() {
        errorMessage = "Ошибка получения данных с сервера.";
        isLoading = false;
      });
      return;
    }

    if (response["status"] == true && response["users"] is List) {
      setState(() {
        users = response["users"] as List<dynamic>;
        timestamp = response["timestamp"] as int?;
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = response["error"] ?? "Неизвестная ошибка.";
        timestamp = response["timestamp"] as int?;
        isLoading = false;
      });
    }
  }

  /// Публичный метод для обновления списка учеников
  Future<void> refresh() async {
    await _loadClassUsers();
  }

  String _formatTimestamp(int ts) {
    final date = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (users.isEmpty) {
      return const Center(child: Text("Ученики не найдены."));
    }

    return RefreshIndicator(
      onRefresh: _loadClassUsers,
      child: ListView.builder(
        itemCount: users.length + 1, // +1 для отображения timestamp
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                timestamp != null
                    ? "Последнее обновление: ${_formatTimestamp(timestamp!)}"
                    : "",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            );
          }
          final user = users[index - 1] as Map<String, dynamic>;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(
                  "${user['last_name']} ${user['first_name']} ${user['middle_name']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Логин: ${user['username']}"),
                  Text("Класс: ${user['class']} (${user['class_id']})"),
                  Text("QR: ${user['qr']}"),
                  Text("Использован: ${user['used'] == true ? 'Да' : 'Нет'}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
