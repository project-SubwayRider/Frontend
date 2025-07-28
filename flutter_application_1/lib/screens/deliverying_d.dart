import 'package:flutter/material.dart';
import '../data/order_history_data.dart'; // OrderHistory import

class DeliveryingDScreen extends StatefulWidget {
  const DeliveryingDScreen({super.key});

  @override
  State<DeliveryingDScreen> createState() => _DeliveryingDScreenState();
}

class _DeliveryingDScreenState extends State<DeliveryingDScreen> {
  bool isCancelled = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final order = args is OrderHistory ? args : orderHistories[1];

    return Scaffold(
      appBar: AppBar(
        title: const Text('배달 받는 사람'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/', // home_screen.dart로 이동
              (route) => false, // 이전 페이지 스택 제거
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCancelled) ...[
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
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('배달 완료 확인'),
                                  content: const Text('정말 완료되었습니까?'),
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
                          '배달 완료/정산',
                          style: TextStyle(color: Colors.blue),
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

              // ✅ 실시간 지하철 정보
              const Align(
                alignment: Alignment.centerRight,
                child: Text('실시간 지하철 정보', style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 24),
            ],

            // ✅ 토글 (무조건 노출)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('배달 받는 사람', style: TextStyle(fontSize: 16)),
                Switch(
                  value: true,
                  onChanged: (value) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/deliverying_base',
                      arguments: orderHistories[0],
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
