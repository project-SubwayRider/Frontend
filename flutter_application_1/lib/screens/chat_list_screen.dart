
import 'package:flutter/material.dart';
import '../data/chat.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatItem> sortedList = List.from(chatList);
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
        case '시간':
          sortedList.sort((a, b) => a.time.compareTo(b.time));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅목록'),
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
              const PopupMenuItem(value: '시간', child: Text('시간 오름차순')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sortedList.length,
        itemBuilder: (context, index) {
          final chat = sortedList[index];
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
                  chat.imagePath,
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
                          text: '${chat.food} 배달 ',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        TextSpan(text: '${chat.from}에서\n'),
                        TextSpan(
                          text: '${chat.to}으로 ',
                          style: const TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: '${chat.time}까지',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
