import 'package:flutter/material.dart';
import '../data/order_history_data.dart'; // 반드시 존재해야 함

class DeliveryingScreen extends StatefulWidget {
  final OrderHistory order;

  const DeliveryingScreen({super.key, required this.order});

  @override
  State<DeliveryingScreen> createState() => _DeliveryingScreenState();
}

class _DeliveryingScreenState extends State<DeliveryingScreen> {
  bool isCancelled = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final order = args is OrderHistory ? args : orderHistories[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('배달 받기'),
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
                child: Text('배달 중인 음식 없음', style: TextStyle(fontSize: 24)),
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

              Text(
                '음식 : ${order.food}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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

              // 팁, 취소, 완료 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '팁 : ${order.tip}원',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('취소 확인'),
                                  content: const Text('진짜 취소하시겠습니까?'),
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
                          '취소',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/review',
                            arguments: order,
                          );
                        },
                        child: const Text(
                          '리뷰 쓰기',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ✅ 네모 박스
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),

              // 실시간 지하철 정보
              const Align(
                alignment: Alignment.centerRight,
                child: Text('실시간 배달자 위치', style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 24),
            ],

            // ✅ 항상 보여지는 토글
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('배달 받는 사람', style: TextStyle(fontSize: 16)),
                Switch(
                  value: false,
                  onChanged: (value) {
                    Navigator.pushNamed(context, '/deliverying_d');
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
