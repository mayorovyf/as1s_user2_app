// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import '../api/login_api.dart';
import '../api/user_data_api.dart';
import '../services/shared_prefs_service.dart';

class ProfilePage extends StatefulWidget {
  final ValueNotifier<int> refreshNotifier;
  const ProfilePage({Key? key, required this.refreshNotifier}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;
  Map<String, dynamic>? userData;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    widget.refreshNotifier.addListener(_onRefresh);
    _checkLoginStatus();
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(_onRefresh);
    super.dispose();
  }

  void _onRefresh() async {
    final apiKey = await SharedPrefsService.getApiKey();
    if (apiKey != null) {
      _fetchUserData(apiKey);
    }
  }

  Future<void> _checkLoginStatus() async {
    final apiKey = await SharedPrefsService.getApiKey();
    if (apiKey != null) {
      await _fetchUserData(apiKey);
    }
  }

  Future<void> _fetchUserData(String apiKey) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final data = await UserDataApi.fetchUserData(apiKey);
    if (data != null) {
      await SharedPrefsService.saveUserData(data);
      setState(() {
        userData = data;
        isLoggedIn = true;
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = "Не удалось получить данные пользователя.";
        isLoading = false;
      });
    }
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    final apiKey = await LoginApi.loginUser(username, password);
    if (apiKey != null) {
      await SharedPrefsService.saveApiKey(apiKey);
      await _fetchUserData(apiKey);
    } else {
      setState(() {
        errorMessage = "Ошибка входа. Проверьте правильность данных.";
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await SharedPrefsService.removeApiKey();
    await SharedPrefsService.removeUserData();
    setState(() {
      isLoggedIn = false;
      userData = null;
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoggedIn ? _buildProfile() : _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (errorMessage != null)
          Text(errorMessage!, style: const TextStyle(color: Colors.red)),
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Логин'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Пароль'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _login,
          child: const Text("Войти"),
        ),
      ],
    );
  }

  Widget _buildProfile() {
    // Отображаем все поля, полученные от сервера
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Имя: ${userData?['first_name'] ?? ''}"),
          Text("Отчество: ${userData?['middle_name'] ?? ''}"),
          Text("Фамилия: ${userData?['last_name'] ?? ''}"),
          Text("Логин: ${userData?['username'] ?? ''}"),
          Text("Класс: ${userData?['class'] ?? ''}"),
          Text("ID класса: ${userData?['class_id'] ?? ''}"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _logout,
            child: const Text("Выйти"),
          ),
        ],
      ),
    );
  }
}
