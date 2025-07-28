// chat.dart

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}

class ChatItem {
  final String title;
  final String from;
  final String to;
  final String imageUrl;

  ChatItem({
    required this.title,
    required this.from,
    required this.to,
    required this.imageUrl,
  });
}

// 채팅 리스트에 보여줄 항목들
final List<ChatItem> chatItems = [
  ChatItem(
    title: '햄버거 배달 노원역에서',
    from: '하계역',
    to: '12:00',
    imageUrl: 'assets/profile.png',
  ),
  ChatItem(
    title: '돈까스 배달 강남역에서',
    from: '강남역',
    to: '09:00',
    imageUrl: 'assets/profile.png',
  ),
  ChatItem(
    title: '짜장면 배달 건대입구역에서',
    from: '잠실역',
    to: '17:00',
    imageUrl: 'assets/profile.png',
  ),
  ChatItem(
    title: '짬뽕 배달 서울역에서',
    from: '신촌역',
    to: '18:00',
    imageUrl: 'assets/profile.png',
  ),
  ChatItem(
    title: '탕수육 배달 중계역에서',
    from: '송산우역',
    to: '01:00',
    imageUrl: 'assets/profile.png',
  ),
];

// 대화 내용 (title을 key로 사용)
Map<String, List<Message>> dummyChats = {
  '햄버거 배달 노원역에서': [
    Message(sender: 'user', text: '안녕하세요'),
    Message(sender: 'other', text: '네 안녕하세요'),
    Message(sender: 'user', text: '어떤 음식 배달해드릴까요?'),
  ],
  '탕수육 배달 중계역에서': [
    Message(sender: 'other', text: '도착까지 얼마나 걸릴까요?'),
    Message(sender: 'user', text: '15분 정도 소요될 예정입니다.'),
  ],
};
