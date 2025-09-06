import 'package:flutter/material.dart';
import '../data/order_history_data.dart';

/// 흑백 모노톤 테마
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
  dividerColor: Colors.black12,
  iconTheme: const IconThemeData(color: Colors.black),
);

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  List<OrderHistory> sortedList = List.from(orderHistories);
  String selectedSort = '시간';

  void _applySort(String criterion) {
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
        case '시간':
          sortedList.sort((a, b) => a.time.compareTo(b.time));
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
          title: const Text('배달 요청 목록'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort),
              onSelected: _applySort,
              itemBuilder:
                  (context) => const [
                    PopupMenuItem(value: '음식명', child: Text('음식명 오름차순')),
                    PopupMenuItem(value: '출발역', child: Text('출발역 오름차순')),
                    PopupMenuItem(value: '도착역', child: Text('도착역 오름차순')),
                    PopupMenuItem(value: '시간', child: Text('시간 오름차순')),
                  ],
            ),
          ],
        ),
        body: Column(
          children: [
            _SortChips(
              selected: selectedSort,
              onSelected: _applySort,
              horizontalPadding: pad,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(pad, 8, pad, 16),
                itemCount: sortedList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final order = sortedList[i];
                  return _RequestTile(
                    order: order,
                    onTap: () {
                      // 상세 화면으로 이동
                      Navigator.pushNamed(
                        context,
                        '/delivery_detail_base',
                        arguments: order,
                      );
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

/// 상단 정렬 칩
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
    final items = const ['음식명', '출발역', '도착역', '시간'];
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

/// 요청 카드 타일
class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.order, this.onTap});
  final OrderHistory order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withOpacity(0.08)),
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
                    order.imagePath,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          width: 64,
                          height: 64,
                          color: Colors.black.withOpacity(0.05),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 20,
                          ),
                        ),
                  ),
                ),
                const SizedBox(width: 14),

                // 본문
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order.food} 배달 요청',
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
                              '${order.from} → ${order.to}',
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
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            order.time,
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
                const Icon(Icons.chevron_right, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
