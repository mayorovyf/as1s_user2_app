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
  // Notifier для обновления QR и Profile страниц (если потребуется)
  final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);
  // GlobalKey для страницы списка учеников
  final GlobalKey<ClassUsersPageState> _classUsersPageKey = GlobalKey<ClassUsersPageState>();

  final List<String> _titles = const [
    'QR Код',
    'Ученики',
    'Профиль',
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ClassUsersPage(key: _classUsersPageKey),
      ProfilePage(refreshNotifier: refreshNotifier),
    ];
  }

  void _onRefreshPressed() {
    if (_currentIndex == 0) {
      // Обновляем список учеников, если открыта соответствующая вкладка
      _classUsersPageKey.currentState?.refresh();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Обновление доступно только на странице "Ученики".')),
      );
    }
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
