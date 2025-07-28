// deliverying_base.dart
import 'package:flutter/material.dart';

class DeliveryingBase extends StatelessWidget {
  final bool isToggleOn;

  const DeliveryingBase({super.key, required this.isToggleOn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배달 중')),
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
                      Navigator.pushReplacementNamed(
                        context,
                        value ? '/deliverying_d' : '/deliverying',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // ⬇️ 본문 중앙 메시지
          const Center(
            child: Text('현재 배달 중입니다.', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}
