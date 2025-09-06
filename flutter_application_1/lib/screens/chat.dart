// lib/screens/chat.dart
import 'package:flutter/material.dart';
import '../data/chat.dart'; // ChatItem(food, from, to, time, imagePath) 를 포함하고 있다고 가정

/// 이 화면만 적용되는 흑백 모노톤 테마 (목록 화면과 톤 맞춤)
final ThemeData _monoTheme = ThemeData(
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
  dividerColor: Colors.black12,
  iconTheme: const IconThemeData(color: Colors.black),
);

/// 채팅 상세 화면
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.item});
  final ChatItem item;

  /// 라우팅으로 arguments를 사용할 때
  /// Navigator.pushNamed(context, ChatScreen.routeName, arguments: chatItem);
  static const routeName = '/chat_detail';

  /// onGenerateRoute에서 사용하려면:
  /// case ChatScreen.routeName:
  ///   final item = settings.arguments as ChatItem;
  ///   return MaterialPageRoute(builder: (_) => ChatScreen(item: item));
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  late List<_Message> _messages;

  @override
  void initState() {
    super.initState();
    // 더미 대화. 필요시 서버/DB에서 교체
    _messages = [
      _Message(
        '안녕하세요! 혹시 오늘 배달 가능하신가요?',
        false,
        DateTime.now().subtract(const Duration(minutes: 35)),
      ),
      _Message(
        '네 가능합니다. 몇 시에 픽업 도와드릴까요?',
        true,
        DateTime.now().subtract(const Duration(minutes: 33)),
      ),
      _Message(
        '09:00에 강남역에서 받을게요.',
        false,
        DateTime.now().subtract(const Duration(minutes: 31)),
      ),
      _Message(
        '확인했습니다. ${widget.item.from}에서 픽업해서 ${widget.item.to}로 이동할게요.',
        true,
        DateTime.now().subtract(const Duration(minutes: 28)),
      ),
      _Message(
        '감사해요! ${widget.item.food} 기대할게요 😄',
        false,
        DateTime.now().subtract(const Duration(minutes: 25)),
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text, true, DateTime.now()));
    });
    _controller.clear();
    // 키보드/전송 후 아래로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width >= 720 ? 24.0 : 14.0;

    return Theme(
      data: _monoTheme,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '${widget.item.food} 채팅',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _HeaderCard(item: widget.item, horizontalPadding: pad),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: EdgeInsets.fromLTRB(pad, 14, pad, 14),
                  itemCount: _messages.length + 1, // 날짜 구분선 포함
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // 최상단에 오늘 날짜 라벨
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DateLabel(date: DateTime.now()),
                      );
                    }
                    final msg = _messages[index - 1];
                    final prev = index - 2 >= 0 ? _messages[index - 2] : null;
                    final showTimeGap =
                        prev == null ||
                        msg.timestamp
                                .difference(prev.timestamp)
                                .inMinutes
                                .abs() >=
                            5;

                    return Padding(
                      padding: EdgeInsets.only(bottom: showTimeGap ? 12 : 6),
                      child: Align(
                        alignment:
                            msg.isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: _Bubble(
                          text: msg.text,
                          isMe: msg.isMe,
                          time: msg.timestamp,
                        ),
                      ),
                    );
                  },
                ),
              ),
              _InputBar(
                controller: _controller,
                onSend: _send,
                horizontalPadding: pad,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 상단 주문 요약 카드 (썸네일 / 경로 / 시간)
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.item, required this.horizontalPadding});
  final ChatItem item;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        12,
        horizontalPadding,
        12,
      ),
      color: Colors.white,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 6),
                color: Color(0x11000000),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.imagePath,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.black.withValues(alpha: 0.05),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 18,
                          ),
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.food} 배달',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${item.from} → ${item.to}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            item.time,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.info_outline, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 날짜 라벨
class _DateLabel extends StatelessWidget {
  const _DateLabel({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final text = _formatDate(date);
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black.withValues(alpha: 0.08))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.black.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.black.withValues(alpha: 0.08))),
      ],
    );
  }

  String _formatDate(DateTime d) {
    final w = ['월', '화', '수', '목', '금', '토', '일'][d.weekday - 1];
    return '${d.year}.${_two(d.month)}.${_two(d.day)} ($w)';
    // 필요하면 intl 패키지로 교체 가능
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}

/// 채팅 말풍선
class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.isMe, required this.time});

  final String text;
  final bool isMe;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.black : Colors.white;
    final fg = isMe ? Colors.white : Colors.black;
    final border =
        isMe ? Colors.transparent : Colors.black.withValues(alpha: 0.12);

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 340),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(isMe ? 14 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 14),
            ),
            border: Border.all(color: border),
            boxShadow: [
              if (!isMe)
                const BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, 4),
                  color: Color(0x09000000),
                ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(color: fg, fontSize: 15, height: 1.35),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatTime(time),
          style: TextStyle(
            fontSize: 11.5,
            color: Colors.black.withValues(alpha: 0.45),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = h < 12 ? '오전' : '오후';
    final hh = h % 12 == 0 ? 12 : h % 12;
    return '$ap $hh:$m';
  }
}

/// 하단 입력 바
class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.horizontalPadding,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          8,
          horizontalPadding,
          10,
        ),
        child: Row(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.12),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, 4),
                      color: Color(0x0F000000),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 44,
              width: 44,
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  onTap: onSend,
                  borderRadius: BorderRadius.circular(999),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 내부 메시지 모델 (예시)
class _Message {
  _Message(this.text, this.isMe, this.timestamp);
  final String text;
  final bool isMe;
  final DateTime timestamp;
}
