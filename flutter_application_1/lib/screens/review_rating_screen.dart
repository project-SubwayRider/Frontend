
import 'package:flutter/material.dart';
import '../data/delivered.dart';
import '../data/review.dart';

class ReviewRatingScreen extends StatefulWidget {
  final DeliveredItem item;
  final ValueChanged<double> onRated;

  const ReviewRatingScreen({
    super.key,
    required this.item,
    required this.onRated,
  });

  @override
  State<ReviewRatingScreen> createState() => _ReviewRatingScreenState();
}

class _ReviewRatingScreenState extends State<ReviewRatingScreen> {
  double rating = 3;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('별점 및 리뷰')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              widget.item.imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
            ),
            const SizedBox(height: 20),
            Text('${widget.item.food} 배달', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Slider(
              value: rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: rating.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            Text('${rating.toStringAsFixed(1)}점', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '리뷰를 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                widget.onRated(rating);
                savedReviews.add(Review(food: widget.item.food, rating: rating, comment: commentController.text));
                debugPrint('리뷰 저장됨: ${commentController.text}');
                Navigator.pop(context);
              },
              child: const Text('저장'),
            )
          ],
        ),
      ),
    );
  }
}
