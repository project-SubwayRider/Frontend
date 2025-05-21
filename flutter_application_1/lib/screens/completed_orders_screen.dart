import 'package:flutter/material.dart';

class CompletedDeliveryScreen extends StatelessWidget {
  const CompletedDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배달 완료 목록')),
      body: const Center(
        child: Text('배달 완료 목록 페이지입니다.', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
