import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배달 내역')),
      body: const Center(
        child: Text('배달 내역 페이지입니다.', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
