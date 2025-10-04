import 'package:flutter/material.dart';

class SettingsDashboardPage extends StatelessWidget {
  const SettingsDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')), 
      body: const Center(child: Text('Ini halaman pengaturan')), 
    );
  }
}
