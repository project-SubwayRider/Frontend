
class Review {
  final String food;
  final double rating;
  final String comment;

  Review({
    required this.food,
    required this.rating,
    required this.comment,
  });

  @override
  String toString() {
    return '[리뷰] ${food} - ⭐ ${rating.toStringAsFixed(1)}\n${comment}\n';
  }
}

final List<Review> savedReviews = [];
