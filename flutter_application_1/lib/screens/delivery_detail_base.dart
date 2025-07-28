import 'package:flutter/material.dart';
import 'delivery_detail.dart';
import 'delivery_detail_d.dart';
import 'deliverying.dart';

class DeliveryDetailBase extends StatelessWidget {
  final bool isToggleOn;

  const DeliveryDetailBase({super.key, required this.isToggleOn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배달 상세 목록')),
      body: Stack(
        children: [
          // ⬅️ 좌상단 토글 위치
          Positioned(
            top: 16,
            left: 16,
            child: Row(
              children: [
                const Text('D 화면'),
                Switch(
                  value: isToggleOn,
                  onChanged: (value) {
                    if (value != isToggleOn) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  value
                                      ? const DeliveryDetailDScreen()
                                      : const DeliveryDetailScreen(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // ⬇️ 본문 중앙 버튼
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeliveryingScreen()),
                );
              },
              child: const Text('배달 중'),
            ),
          ),
        ],
      ),
    );
  }
}
