class DeliveredItem {
  final String food;
  final String from;
  final String to;
  final String time;
  final String imagePath;

  DeliveredItem({
    required this.food,
    required this.from,
    required this.to,
    required this.time,
    required this.imagePath,
  });
}

final List<DeliveredItem> deliveredList = [
  DeliveredItem(
    food: '김밥',
    from: '강남역',
    to: '홍대입구역',
    time: '12:00',
    imagePath: 'assets/kimbap.jpg',
  ),
  DeliveredItem(
    food: '떡볶이',
    from: '서울역',
    to: '건대입구역',
    time: '13:00',
    imagePath: 'assets/tteokbok.jpg',
  ),
  DeliveredItem(
    food: '치킨',
    from: '신촌역',
    to: '잠실역',
    time: '14:30',
    imagePath: 'assets/chicken.jpg',
  ),
  DeliveredItem(
    food: '피자',
    from: '노원역',
    to: '사당역',
    time: '15:10',
    imagePath: 'assets/pizza.jpg',
  ),
  DeliveredItem(
    food: '라면',
    from: '마포역',
    to: '연신내역',
    time: '16:20',
    imagePath: 'assets/ramyeon.jpg',
  ),
];
