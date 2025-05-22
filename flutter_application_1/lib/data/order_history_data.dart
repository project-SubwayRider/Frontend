
class OrderHistory {
  final String food;
  final String from;
  final String to;
  final String time;
  final String imagePath;
  final int tip;

  OrderHistory({
    required this.food,
    required this.from,
    required this.to,
    required this.time,
    required this.imagePath,
    required this.tip,
  });
}

final List<OrderHistory> orderHistories = [
  OrderHistory(food: '김밥', from: '강남역', to: '건대입구역', time: '12:00', imagePath: 'assets/images/kimbap.png', tip: 1000),
  OrderHistory(food: '햄버거', from: '신촌역', to: '이대역', time: '13:10', imagePath: 'assets/images/burger.png', tip: 2000),
  OrderHistory(food: '라면', from: '서울역', to: '마포역', time: '14:30', imagePath: 'assets/images/ramen.png', tip: 1500),
  OrderHistory(food: '초밥', from: '홍대입구역', to: '합정역', time: '15:20', imagePath: 'assets/images/sushi.png', tip: 3000),
  OrderHistory(food: '샐러드', from: '잠실역', to: '송파역', time: '16:40', imagePath: 'assets/images/salad.png', tip: 2500),
];
