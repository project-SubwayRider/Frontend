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
  double rating = 3.0;
  final TextEditingController commentController = TextEditingController();

  // 이 화면 전용 모노톤 테마
  ThemeData get _monoTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      surfaceTint: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.3,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    sliderTheme: const SliderThemeData(
      activeTrackColor: Colors.black,
      inactiveTrackColor: Colors.black12,
      thumbColor: Colors.black,
      overlayColor: Color(0x22000000),
      valueIndicatorColor: Colors.black,
      valueIndicatorTextStyle: TextStyle(color: Colors.white),
    ),
  );

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width >= 720 ? 28.0 : 18.0;

    return Theme(
      data: _monoTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text('별점 및 리뷰')),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad, 10, pad, 14),
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
              child: const Text('저장'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(pad, 12, pad, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageCard(imagePath: widget.item.imagePath),
              const SizedBox(height: 14),

              Text(
                '${widget.item.food} 배달',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.place_outlined, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${widget.item.from} → ${widget.item.to}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ⭐ 별점 프리뷰
              Center(child: _StarRow(rating: rating)),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  '${rating.toStringAsFixed(1)}점',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 슬라이더 (1.0~5.0, 0.5단위)
              Slider(
                value: rating,
                min: 1,
                max: 5,
                divisions: 8, // 0.5 단위
                label: rating.toStringAsFixed(1),
                onChanged: (v) => setState(() => rating = v),
              ),

              const SizedBox(height: 16),
              const Text(
                '리뷰',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: commentController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: '음식/배달에 대한 솔직한 리뷰를 남겨주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    widget.onRated(rating);
    savedReviews.add(
      Review(
        food: widget.item.food,
        rating: rating,
        comment: commentController.text.trim(),
      ),
    );
    debugPrint('리뷰 저장됨: ${commentController.text.trim()}');
    Navigator.pop(context);
  }
}

/* ───────────────────── Sub Widgets ───────────────────── */

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 6),
            color: Color(0x11000000),
          ),
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 120,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            errorBuilder:
                (_, __, ___) => Container(
                  color: Colors.black.withValues(alpha: 0.05),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image, size: 28),
                ),
          ),
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    // 반개 처리: 4.3 -> ★★★★☆ (마지막은 반개 느낌으로 border)
    int full = rating.floor();
    bool half = (rating - full) >= 0.5 && full < 5;

    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < full) {
        stars.add(const Icon(Icons.star, size: 22, color: Colors.black));
      } else if (i == full && half) {
        stars.add(const Icon(Icons.star_half, size: 22, color: Colors.black));
      } else {
        stars.add(
          Icon(
            Icons.star_border,
            size: 22,
            color: Colors.black.withValues(alpha: 0.35),
          ),
        );
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}
