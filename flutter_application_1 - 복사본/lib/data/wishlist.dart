class WishlistItem {
  final String food;
  final String from;
  final String to;
  final String time;
  final String imagePath;

  WishlistItem({
    required this.food,
    required this.from,
    required this.to,
    required this.time,
    required this.imagePath,
  });
}

final List<WishlistItem> wishlist = [
  WishlistItem(
    food: '마라탕',
    from: '건대입구역',
    to: '왕십리역',
    time: '18:00',
    imagePath: 'assets/1.png',
  ),
  WishlistItem(
    food: '초밥',
    from: '홍대입구역',
    to: '합정역',
    time: '19:30',
    imagePath: 'assets/2.png',
  ),
  WishlistItem(
    food: '냉면',
    from: '잠실역',
    to: '신천역',
    time: '12:10',
    imagePath: 'assets/3.png',
  ),
  WishlistItem(
    food: '비빔밥',
    from: '서울역',
    to: '충무로역',
    time: '13:45',
    imagePath: 'assets/4.png',
  ),
  WishlistItem(
    food: '돈까스',
    from: '신촌역',
    to: '이대역',
    time: '17:00',
    imagePath: 'assets/5.png',
  ),
];
