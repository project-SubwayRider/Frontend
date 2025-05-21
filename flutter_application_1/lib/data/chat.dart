class ChatItem {
  final String food;
  final String from;
  final String to;
  final String time;
  final String imagePath; // ✅ 이미지 경로 추가

  ChatItem({
    required this.food,
    required this.from,
    required this.to,
    required this.time,
    required this.imagePath,
  });
}

// 예시 채팅 목록
final List<ChatItem> chatList = [
  ChatItem(
    food: '햄버거',
    from: '노원역',
    to: '하계역',
    time: '12:00',
    imagePath: 'assets/1.png',
  ),
  ChatItem(
    food: '동파육',
    from: '강남역',
    to: '강남역',
    time: '09:00',
    imagePath: 'assets/2.png',
  ),
  ChatItem(
    food: '짜장면',
    from: '건대입구역',
    to: '잠실역',
    time: '17:00',
    imagePath: 'assets/3.png',
  ),
  ChatItem(
    food: '짬뽕',
    from: '서울역',
    to: '신촌역',
    time: '18:00',
    imagePath: 'assets/4.png',
  ),
  ChatItem(
    food: '탕수육육',
    from: '중계역',
    to: '송찬우역',
    time: '01:00',
    imagePath: 'assets/5.png',
  ),
];
