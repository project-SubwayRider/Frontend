
import 'package:flutter/material.dart';
import '../data/completed.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  State<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  List<CompletedOrder> sortedList = List.from(completedOrders);
  String selectedSort = '음식명';

  void sortBy(String criterion) {
    setState(() {
      selectedSort = criterion;
      switch (criterion) {
        case '음식명':
          sortedList.sort((a, b) => a.food.compareTo(b.food));
          break;
        case '출발역':
          sortedList.sort((a, b) => a.from.compareTo(b.from));
          break;
        case '도착역':
          sortedList.sort((a, b) => a.to.compareTo(b.to));
          break;
        case '배달시간':
          sortedList.sort((a, b) => a.time.compareTo(b.time));
          break;
        case '팁':
          sortedList.sort((a, b) => a.tip.compareTo(b.tip));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('배달 완료 내역'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: sortBy,
            itemBuilder: (context) => [
              const PopupMenuItem(value: '음식명', child: Text('음식명 오름차순')),
              const PopupMenuItem(value: '출발역', child: Text('출발역 오름차순')),
              const PopupMenuItem(value: '도착역', child: Text('도착역 오름차순')),
              const PopupMenuItem(value: '배달시간', child: Text('배달시간 오름차순')),
              const PopupMenuItem(value: '팁', child: Text('팁 오름차순')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sortedList.length,
        itemBuilder: (context, index) {
          final item = sortedList[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Image.asset(
                  item.imagePath,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Text('사진'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '${item.food} 배달 ',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        TextSpan(text: '${item.from}에서\n'),
                        TextSpan(
                          text: '${item.to}으로 ',
                          style: const TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: '${item.time}까지\n',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        TextSpan(
                          text: '💰 팁: ${item.tip}원',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
