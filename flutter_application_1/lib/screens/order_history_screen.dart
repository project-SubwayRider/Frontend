import 'package:flutter/material.dart';
import '../data/order_history_data.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderHistory> sortedList = List.from(orderHistories);
  String selectedSort = '음식명';

  // 이 화면 전용 흑백 모노톤 테마
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

  void sortBy(String criterion) {
    setState(() {
      selectedSort = criterion;
      switch (criterion) {
        case '음식명':
          sortedList.sort((a, b) => a.food.compareTo(b.food));
          break;
        case '출발역':
          sortedList.sort((a, b) => a.from.compareTo(b.from));
          break;
        case '도착역':
          sortedList.sort((a, b) => a.to.compareTo(b.to));
          break;
        case '배달시간':
          sortedList.sort((a, b) => a.time.compareTo(b.time));
          break;
        case '팁':
          sortedList.sort((a, b) => a.tip.compareTo(b.tip));
          break;
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
          title: const Text('배달 내역'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort),
              onSelected: sortBy,
              itemBuilder:
                  (context) => const [
                    PopupMenuItem(value: '음식명', child: Text('음식명 오름차순')),
                    PopupMenuItem(value: '출발역', child: Text('출발역 오름차순')),
                    PopupMenuItem(value: '도착역', child: Text('도착역 오름차순')),
                    PopupMenuItem(value: '배달시간', child: Text('배달시간 오름차순')),
                    PopupMenuItem(value: '팁', child: Text('팁 오름차순')),
                  ],
            ),
          ],
        ),
        body: Column(
          children: [
            _SortChips(
              selected: selectedSort,
              onSelected: sortBy,
              horizontalPadding: pad,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(pad, 8, pad, 24),
                itemCount: sortedList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = sortedList[index];
                  return _HistoryTile(
                    imagePath: item.imagePath,
                    title: '${item.food} 배달',
                    subtitle: '${item.from} → ${item.to}',
                    time: item.time,
                    tip: item.tip,
                    onTap: () {
                      // 필요 시 상세 페이지 이동
                      // Navigator.pushNamed(context, '/delivery_detail_base', arguments: item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────── Sub Widgets ───────────────────── */

class _SortChips extends StatelessWidget {
  const _SortChips({
    required this.selected,
    required this.onSelected,
    required this.horizontalPadding,
  });

  final String selected;
  final ValueChanged<String> onSelected;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    const items = ['음식명', '출발역', '도착역', '배달시간', '팁'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 8),
      child: Row(
        children:
            items.map((label) {
              final active = label == selected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(label),
                  selected: active,
                  labelStyle: TextStyle(
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    color: active ? Colors.white : Colors.black87,
                  ),
                  selectedColor: Colors.black,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black12),
                  onSelected: (_) => onSelected(label),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.tip,
    this.onTap,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String time;
  final int tip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
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
                // 썸네일
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          width: 64,
                          height: 64,
                          color: Colors.black.withValues(alpha: 0.06),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 20,
                          ),
                        ),
                  ),
                ),
                const SizedBox(width: 12),

                // 텍스트 영역
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 출발 → 도착
                      Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              subtitle,
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
                      const SizedBox(height: 2),

                      // 시간
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            time,
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

                const SizedBox(width: 10),

                // 팁 배지
                _TipBadge(tip: tip),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TipBadge extends StatelessWidget {
  const _TipBadge({required this.tip});
  final int tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_money, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            '$tip원',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
