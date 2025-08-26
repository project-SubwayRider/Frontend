import 'package:flutter/material.dart';
import '../data/order_history_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 800;

    final titleFs = (size.width * 0.075).clamp(24.0, 40.0).toDouble();
    final subtitleFs = (titleFs * 0.42).clamp(11.0, 16.0);
    final heroSide = (size.width * 0.46).clamp(180.0, 320.0).toDouble();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('홈'),
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 28 : 18,
            vertical: isWide ? 22 : 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 브랜드 헤더
              const SizedBox(height: 4),
              Text(
                '서브웨이 드라이버',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFs,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  height: 1.15,
                  fontFamily: 'NeoDgm',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '가까운 드라이버와 빠르게 연결하세요',
                style: TextStyle(
                  fontSize: subtitleFs,
                  color: Colors.black54,
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 히어로 이미지
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    'assets/Title.png',
                    width: heroSide,
                    height: heroSide,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 주요 CTA
              _PrimaryActions(
                onRequestTap: () => Navigator.pushNamed(context, '/delivery'),
                onListTap: () => Navigator.pushNamed(context, '/requests'),
                isWide: isWide,
              ),

              const SizedBox(height: 18),

              // 구분선 + 섹션 타이틀
              _SectionHeader(title: '상세 메뉴'),

              const SizedBox(height: 12),

              // 빠른 메뉴 그리드
              _QuickMenuGrid(
                tiles: [
                  _Tile(
                    label: '채팅 목록',
                    asset: 'assets/Icon3.png',
                    onTap: () => Navigator.pushNamed(context, '/chat'),
                  ),
                  _Tile(
                    label: 'My 화면',
                    asset: 'assets/Icon2.png',
                    onTap: () => Navigator.pushNamed(context, '/my'),
                  ),
                  _Tile(
                    label: '배달 상세',
                    asset: 'assets/Icon4.png',
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          '/delivery_detail_base',
                          arguments: orderHistories[0],
                        ),
                  ),
                  _Tile(
                    label: '배달 중',
                    asset: 'assets/Icon1.png',
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          '/deliverying_base',
                          arguments: orderHistories[1],
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// 상단 주요 CTA (Filled + Outlined)
class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({
    required this.onRequestTap,
    required this.onListTap,
    required this.isWide,
  });

  final VoidCallback onRequestTap;
  final VoidCallback onListTap;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final buttonHeight = isWide ? 56.0 : 52.0;
    final spacing = isWide ? 12.0 : 10.0;

    // ✅ 검정 배경 + 흰 텍스트
    Widget request = SizedBox(
      height: buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onRequestTap,
        icon: const Icon(Icons.directions_bike_outlined, color: Colors.white),
        label: const Text('배달 요청하기'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );

    // ✅ 흰 배경 + 검정 글씨 + 검정 테두리
    Widget list = SizedBox(
      height: buttonHeight,
      child: OutlinedButton.icon(
        onPressed: onListTap,
        icon: const Icon(Icons.list_alt_outlined, color: Colors.black),
        label: const Text('요청 목록 보기'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          side: const BorderSide(color: Colors.black, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );

    if (isWide) {
      return Row(
        children: [
          Expanded(child: request),
          SizedBox(width: spacing),
          Expanded(child: list),
        ],
      );
    }
    return Column(children: [request, SizedBox(height: spacing), list]);
  }
}

/// 섹션 헤더(얇은 구분선 포함)
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.black.withOpacity(0.06),
          ),
        ),
      ],
    );
  }
}

/// 빠른 메뉴 그리드(카드형)
class _QuickMenuGrid extends StatelessWidget {
  const _QuickMenuGrid({required this.tiles});
  final List<_Tile> tiles;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final crossCount = w >= 1080 ? 4 : 2;
    final aspect =
        w >= 1080
            ? 1.25
            : w >= 600
            ? 1.20
            : 1.10; // 카드 비율(조금 더 넉넉하게)

    return GridView.builder(
      itemCount: tiles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: aspect,
      ),
      itemBuilder: (context, i) => _QuickCard(tile: tiles[i]),
    );
  }
}

class _Tile {
  final String label;
  final String asset;
  final VoidCallback onTap;
  _Tile({required this.label, required this.asset, required this.onTap});
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({required this.tile});
  final _Tile tile;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: tile.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 6),
                color: Color(0x11000000),
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  tile.asset,
                  width: 48, // ✅ 아이콘 크기 키움
                  height: 48,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Text(
                  tile.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.5, // ✅ 글자 크기 키움
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
