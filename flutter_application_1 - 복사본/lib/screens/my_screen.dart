
import 'package:flutter/material.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'title': '회원정보', 'route': '/profile'},
      {'title': '주문리뷰', 'route': '/review'},
      {'title': '환경설정', 'route': '/settings'},
      {'title': '찜목록', 'route': '/wishlist'},
      {'title': '배달 완료 목록', 'route': '/completed'},
      {'title': '배달 내역', 'route': '/history'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: menuItems.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            title: Text(item['title'], style: const TextStyle(fontSize: 18)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, item['route']);
            },
          );
        },
      ),
    );
  }
}
