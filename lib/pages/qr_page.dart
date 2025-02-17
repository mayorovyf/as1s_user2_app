// lib/pages/qr_page.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/shared_prefs_service.dart';

class QRPage extends StatefulWidget {
  final ValueNotifier<int> refreshNotifier;
  const QRPage({Key? key, required this.refreshNotifier}) : super(key: key);

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String? qrData;

  @override
  void initState() {
    super.initState();
    widget.refreshNotifier.addListener(_onRefresh);
    _loadQRData();
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(_onRefresh);
    super.dispose();
  }

  void _onRefresh() {
    _loadQRData();
  }

  Future<void> _loadQRData() async {
    final userData = await SharedPrefsService.getUserData();
    setState(() {
      // Извлекаем значение поля 'qr' из сохранённых данных пользователя
      qrData = userData != null ? userData['qr'] as String? : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (qrData != null && qrData!.isNotEmpty)
          ? QrImageView(
        data: qrData!,
        version: QrVersions.auto,
        size: 200.0,
      )
          : const Text("Нет данных для QR. Пожалуйста, войдите в систему."),
    );
  }
}
