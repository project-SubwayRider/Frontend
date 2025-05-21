import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('찜목록')),
      body: const Center(
        child: Text('찜목록 페이지입니다.', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
