
import 'package:flutter/material.dart';
import '../data/delivered.dart';
import 'review_rating_screen.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final Map<int, double> ratings = {};

  void navigateToRating(int index) async {
    final item = deliveredList[index];
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewRatingScreen(
          item: item,
          onRated: (score) {
            setState(() {
              ratings[index] = score;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주문리뷰'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: deliveredList.length,
        itemBuilder: (context, index) {
          final item = deliveredList[index];
          final rating = ratings[index];
          return GestureDetector(
            onTap: () => navigateToRating(index),
            child: Container(
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
                            text: '${item.time}까지',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          if (rating != null)
                            TextSpan(
                              text: '\n⭐ ${rating.toStringAsFixed(1)}점',
                              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
