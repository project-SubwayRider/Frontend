import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleFontSize =
        (size.width * 0.08).clamp(26.0, 44.0).toDouble(); // 반응형 타이틀
    final imageSide =
        (size.width * 0.55).clamp(200.0, 380.0).toDouble(); // 반응형 이미지

    return Scaffold(
<<<<<<< Updated upstream
      appBar: AppBar(title: const Text('홈')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/delivery');
              },
              child: const Text('배달 요청하기'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/requests');
              },
              child: const Text('배달 요청 목록 보기'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
              child: const Text('채팅 목록'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/my');
              },
              child: const Text('My 화면'),
            ),
          ],
=======
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('홈'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                '서브웨이 드라이버',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'NeoDgm',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/Title.png',
                    width: imageSide,
                    height: imageSide,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 액션 그리드
              _ActionGrid(
                tiles: [
                  _ActionTileData(
                    label: '배달 요청하기',
                    asset: 'assets/Icon1.png',
                    onTap: () => Navigator.pushNamed(context, '/delivery'),
                  ),
                  _ActionTileData(
                    label: '요청 목록 보기',
                    asset: 'assets/Icon1.png',
                    onTap: () => Navigator.pushNamed(context, '/requests'),
                  ),
                  _ActionTileData(
                    label: '채팅 목록',
                    asset: 'assets/Icon1.png',
                    onTap: () => Navigator.pushNamed(context, '/chat'),
                  ),
                  _ActionTileData(
                    label: 'My 화면',
                    asset: 'assets/Icon1.png',
                    onTap: () => Navigator.pushNamed(context, '/my'),
                  ),
                  _ActionTileData(
                    label: '배달 상세',
                    asset: 'assets/Icon1.png',
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          '/delivery_detail_base',
                          arguments: orderHistories[0],
                        ),
                  ),
                  _ActionTileData(
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
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.tiles});

  final List<_ActionTileData> tiles;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 버튼 높이를 살짝 줄이기 위해 비율을 키움
    final childAspectRatio =
        width >= 800
            ? 1.35
            : width >= 600
            ? 1.25
            : 1.20;

    return GridView.builder(
      itemCount: tiles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10, // 간격 살짝 줄임
        crossAxisSpacing: 10,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final t = tiles[index];
        return _ActionTile(label: t.label, asset: t.asset, onTap: t.onTap);
      },
    );
  }
}

class _ActionTileData {
  final String label;
  final String asset;
  final VoidCallback onTap;

  _ActionTileData({
    required this.label,
    required this.asset,
    required this.onTap,
  });
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    super.key,
    required this.label,
    required this.asset,
    required this.onTap,
  });

  final String label;
  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Material 3 느낌의 카드형 타일 (크기 살짝 축소 버전)
    return Material(
      color: const Color(0xFFF7F9F9),
      borderRadius: BorderRadius.circular(18), // 모서리 약간 덜 둥글게
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: Colors.teal.withOpacity(0.12),
        highlightColor: Colors.teal.withOpacity(0.06),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(0, 4),
                color: Color(0x1A000000), // 은은한 그림자
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ), // 패딩 줄임
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  asset,
                  width: 30, // 아이콘 크기 줄임
                  height: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13, // 폰트 조금 작게
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
>>>>>>> Stashed changes
        ),
      ),
    );
  }
}
