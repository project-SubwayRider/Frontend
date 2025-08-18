import 'package:flutter/material.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  // 이 화면만 적용되는 흑백 모노톤 테마
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
    final pad = MediaQuery.of(context).size.width >= 720 ? 24.0 : 16.0;

    // 메뉴 데이터 + 아이콘 매핑
    final List<_MenuItem> menuItems = [
      _MenuItem('회원정보', Icons.person_outline, '/profile'),
      _MenuItem('주문리뷰', Icons.rate_review_outlined, '/review'),
      _MenuItem('환경설정', Icons.settings_outlined, '/settings'),
      _MenuItem('찜목록', Icons.favorite_border, '/wishlist'),
      _MenuItem('배달 완료 목록', Icons.done_all, '/completed'),
      _MenuItem('배달 내역', Icons.history, '/history'),
    ];

    return Theme(
      data: _monoTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text('My')),
        body: ListView(
          padding: EdgeInsets.fromLTRB(pad, 12, pad, 24),
          children: [
            // 상단 프로필 카드
            _ProfileHeader(
              name: '내 계정',
              description: '프로필을 설정해 보세요',
              onEdit: () {
                // 프로필 편집 이동 등
                Navigator.pushNamed(context, '/profile');
              },
            ),
            const SizedBox(height: 16),

            // 섹션 타이틀
            const _SectionTitle('메뉴'),

            const SizedBox(height: 8),

            // 메뉴 카드 리스트
            ...menuItems.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _SettingTile(
                  title: m.title,
                  icon: m.icon,
                  onTap: () => Navigator.pushNamed(context, m.route),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─────────────────────────  위젯들  ───────────────────────── */

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.description,
    required this.onEdit,
  });

  final String name;
  final String description;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 6),
            color: Color(0x11000000),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // 아바타
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.06),
            ),
            child: const Icon(Icons.person_outline, size: 28),
          ),
          const SizedBox(width: 12),

          // 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13.5, color: Colors.black54),
                ),
              ],
            ),
          ),

          // 편집 버튼
          OutlinedButton(
            onPressed: onEdit,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black, width: 1.0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              minimumSize: Size.zero,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('편집'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
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
          child: Container(
            height: 1,
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ─────────────────────────  모델  ───────────────────────── */

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;
  _MenuItem(this.title, this.icon, this.route);
}
