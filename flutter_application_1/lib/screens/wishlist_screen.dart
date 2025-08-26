import 'package:flutter/material.dart';
import '../data/wishlist.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<WishlistItem> wishlistItems;

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

  @override
  void initState() {
    super.initState();
    wishlistItems = List.from(wishlist);
  }

  void _removeItem(int index) {
    final removed = wishlistItems[index];
    setState(() {
      wishlistItems.removeAt(index);
    });

    // 되돌리기 스낵바
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('찜에서 제거됨: ${removed.food}'),
          action: SnackBarAction(
            label: '되돌리기',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                wishlistItems.insert(index, removed);
              });
            },
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width >= 720 ? 24.0 : 14.0;

    return Theme(
      data: _monoTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('찜목록'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body:
            wishlistItems.isEmpty
                ? _EmptyState(padding: pad)
                : ListView.separated(
                  padding: EdgeInsets.fromLTRB(pad, 12, pad, 24),
                  itemCount: wishlistItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = wishlistItems[index];
                    return _WishTile(
                      imagePath: item.imagePath,
                      title: '${item.food} 배달',
                      subtitle: '${item.from} → ${item.to}',
                      time: item.time,
                      onDelete: () => _removeItem(index),
                    );
                  },
                ),
      ),
    );
  }
}

/* ───────────────────── Sub Widgets ───────────────────── */

class _WishTile extends StatelessWidget {
  const _WishTile({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onDelete,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // 상세로 이동하려면 필요 시 라우팅 추가
          // Navigator.pushNamed(context, '/delivery_detail_base', arguments: ...);
        },
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

                // 텍스트
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
                      // 출발→도착
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

                const SizedBox(width: 8),

                // 삭제 버튼
                IconButton(
                  tooltip: '찜 목록에서 제거',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_forever),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.padding});
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding, 40, padding, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border, size: 52),
            const SizedBox(height: 12),
            const Text(
              '찜한 항목이 없어요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '마음에 드는 배달 요청을 찜해두고 빠르게 확인해 보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
