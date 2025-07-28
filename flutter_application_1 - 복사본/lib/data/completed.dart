class CompletedOrder {
  final String food;
  final String from;
  final String to;
  final String time;
  final String imagePath;
  final int tip;

  CompletedOrder({
    required this.food,
    required this.from,
    required this.to,
    required this.time,
    required this.imagePath,
    required this.tip,
  });
}

final List<CompletedOrder> completedOrders = [
  CompletedOrder(
    food: '햄버거',
    from: '강남역',
    to: '홍대입구역',
    time: '12:00',
    imagePath: 'assets/1.png',
    tip: 3000,
  ),
  CompletedOrder(
    food: '치킨',
    from: '잠실역',
    to: '건대입구역',
    time: '13:10',
    imagePath: 'assets/2.png',
    tip: 2500,
  ),
  CompletedOrder(
    food: '떡볶이',
    from: '서울역',
    to: '마포역',
    time: '14:30',
    imagePath: 'assets/3.png',
    tip: 1500,
  ),
  CompletedOrder(
    food: '초밥',
    from: '신촌역',
    to: '이대역',
    time: '15:40',
    imagePath: 'assets/4.png',
    tip: 4000,
  ),
  CompletedOrder(
    food: '파스타',
    from: '연신내역',
    to: '불광역',
    time: '17:00',
    imagePath: 'assets/5.png',
    tip: 3500,
  ),
];
