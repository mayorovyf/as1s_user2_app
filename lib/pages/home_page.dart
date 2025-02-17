// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'qr_page.dart';
import 'class_users_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);

  final List<String> _titles = const [
    'Ученики',
    'Профиль',
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ClassUsersPage(),
      ProfilePage(refreshNotifier: refreshNotifier),
    ];
  }

  void _onRefreshPressed() {
    // Обновляем данные для страниц, подписанных на refreshNotifier (QR и Profile)
    refreshNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefreshPressed,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Ученики'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
