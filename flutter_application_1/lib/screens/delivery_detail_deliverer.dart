import 'package:flutter/material.dart';
import '../data/order_history_data.dart'; // OrderHistory import

class DeliveryDetailDelivererScreen extends StatefulWidget {
  const DeliveryDetailDelivererScreen({super.key});

  @override
  State<DeliveryDetailDelivererScreen> createState() =>
      _DeliveryDetailDelivererScreenState();
}

class _DeliveryDetailDelivererScreenState
    extends State<DeliveryDetailDelivererScreen> {
  bool isCancelled = false;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final order = args is OrderHistory ? args : orderHistories[1];

    return Scaffold(
      appBar: AppBar(
        title: const Text('배달 하기'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/', // home_screen.dart로 이동
              (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isCancelled)
              const Center(
                child: Text('배달 대기 음식 없음', style: TextStyle(fontSize: 24)),
              )
            else ...[
              // 이미지
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    order.imagePath,
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 음식 + 찜 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '음식 : ${order.food}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite ? '찜 목록에 추가되었습니다' : '찜 목록에서 제거되었습니다',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text('출발역 : ${order.from}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),

              Text('도착역 : ${order.to}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),

              Text(
                '배달시간 : ${order.time}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '팁 : ${order.tip}원',
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('배달 시작 확인'),
                              content: const Text('정말 배달 시작하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      isCancelled = true;
                                    });
                                  },
                                  child: const Text('네'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('아니오'),
                                ),
                              ],
                            ),
                      );
                    },
                    child: const Text(
                      '배달 시작',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // ✅ 항상 표시되는 토글 버튼
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('배달 받는 사람', style: TextStyle(fontSize: 16)),
                Switch(
                  value: true,
                  onChanged: (value) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/delivery_detail_base',
                      arguments: orderHistories[0], // 요청자용 데이터
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
