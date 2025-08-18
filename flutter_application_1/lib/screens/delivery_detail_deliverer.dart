import 'package:flutter/material.dart';
import '../data/order_history_data.dart';

class DeliveryDetailDelivererScreen extends StatefulWidget {
  const DeliveryDetailDelivererScreen({super.key});

  @override
  State<DeliveryDetailDelivererScreen> createState() =>
      _DeliveryDetailDelivererScreenState();
}

class _DeliveryDetailDelivererScreenState
    extends State<DeliveryDetailDelivererScreen> {
  bool isCancelled = false;
  bool isFavorite = false;

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
    dividerColor: Colors.black12,
    iconTheme: const IconThemeData(color: Colors.black),
  );

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final order = args is OrderHistory ? args : orderHistories[1];

    final pad = MediaQuery.of(context).size.width >= 720 ? 28.0 : 18.0;

    return Theme(
      data: _monoTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('배달 하기'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(pad, 12, pad, 24),
          child:
              isCancelled
                  ? const Center(
                    child: Text(
                      '배달 대기 음식 없음',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ImageCard(imagePath: order.imagePath),
                        const SizedBox(height: 16),

                        // 상단: 음식명 + 찜 버튼
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '음식: ${order.food}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                setState(() => isFavorite = !isFavorite);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? '찜 목록에 추가되었습니다'
                                          : '찜 목록에서 제거되었습니다',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                              ),
                              label: Text(isFavorite ? '찜 됨' : '찜'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        _InfoCard(order: order),
                        const SizedBox(height: 16),

                        // 액션 버튼들
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _confirmStart,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.black),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                child: const Text('배달 시작'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // 드라이버가 고객에게 문의할 때 (예: 채팅으로 이동)
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                child: const Text('문의하기'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 역할 토글
                        _RoleSwitch(order: order),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  void _confirmStart() {
    showDialog(
      context: context,
      builder:
          (_) => Theme(
            data: _monoTheme,
            child: AlertDialog(
              title: const Text('배달 시작 확인'),
              content: const Text('정말 배달을 시작하시겠습니까?'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => isCancelled = true);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                  ),
                  child: const Text('네'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: Colors.black87),
                  child: const Text('아니오'),
                ),
              ],
            ),
          ),
    );
  }
}

/* ─────────────────────  Sub Widgets  ───────────────────── */

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
        child: AspectRatio(
          aspectRatio: 3 / 2,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Container(
                  color: Colors.black.withValues(alpha: 0.05),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 28),
                ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.order});
  final OrderHistory order;

  @override
  Widget build(BuildContext context) {
    Widget row(IconData icon, String label, String value) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          SizedBox(
            width: 68,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15.0))),
        ],
      );
    }

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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row(Icons.place_outlined, '출발역', order.from),
          const SizedBox(height: 10),
          row(Icons.flag_outlined, '도착역', order.to),
          const SizedBox(height: 10),
          row(Icons.access_time, '배달시간', order.time),
          const SizedBox(height: 10),
          row(Icons.attach_money, '팁', '${order.tip}원'),
        ],
      ),
    );
  }
}

class _RoleSwitch extends StatelessWidget {
  const _RoleSwitch({required this.order});
  final OrderHistory order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.swap_horiz, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              '배달 받는 사람',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
            ),
          ),
          Switch(
            value: true,
            activeColor: Colors.white,
            activeTrackColor: Colors.black,
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: Colors.black.withValues(alpha: 0.35),
            onChanged: (v) {
              Navigator.pushReplacementNamed(
                context,
                '/delivery_detail_base',
                arguments: orderHistories[0],
              );
            },
          ),
        ],
      ),
    );
  }
}
