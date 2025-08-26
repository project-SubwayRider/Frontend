import 'package:flutter/material.dart';
import '../data/profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
    final p = userProfile;
    final pad = MediaQuery.of(context).size.width >= 720 ? 24.0 : 16.0;

    return Theme(
      data: _monoTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text('회원정보')),
        body: ListView(
          padding: EdgeInsets.fromLTRB(pad, 12, pad, 24),
          children: [
            // 프로필 헤더 카드
            _ProfileHeader(
              imagePath: p.profileImage,
              name: p.name,
              nickname: p.nickname,
              phone: p.phoneNumber,
              onEdit: () => Navigator.pushNamed(context, '/profile_edit'),
            ),
            const SizedBox(height: 16),

            const _SectionTitle('기본 정보'),
            const SizedBox(height: 8),
            _InfoCard(
              items: [
                _InfoRow(icon: Icons.perm_identity, label: '아이디', value: p.id),
                _InfoRow(
                  icon: Icons.badge_outlined,
                  label: '이름',
                  value: p.name,
                ),
                _InfoRow(icon: Icons.tag, label: '닉네임', value: p.nickname),
                _InfoRow(
                  icon: Icons.lock_outline,
                  label: '비밀번호',
                  value: p.password,
                ),
                _InfoRow(
                  icon: Icons.cake_outlined,
                  label: '생년월일',
                  value: p.birthdate,
                ),
                _InfoRow(
                  icon: Icons.phone_iphone,
                  label: '휴대전화번호',
                  value: p.phoneNumber,
                ),
                _InfoRow(
                  icon: Icons.event_available,
                  label: '가입날짜',
                  value: p.joinDate,
                ),
                _InfoRow(
                  icon: Icons.thermostat,
                  label: '매너온도',
                  value: p.mannerTemp,
                ),
              ],
            ),
            const SizedBox(height: 16),

            const _SectionTitle('이동/주소'),
            const SizedBox(height: 8),
            _InfoCard(
              items: [
                _InfoRow(
                  icon: Icons.train_outlined,
                  label: '출근역',
                  value: p.startStation,
                ),
                _InfoRow(icon: Icons.train, label: '퇴근역', value: p.endStation),
                _InfoRow(
                  icon: Icons.home_outlined,
                  label: '거주지주소',
                  value: p.address,
                ),
              ],
            ),

            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.maybePop(context),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────── Sub Widgets ───────────────────── */

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.imagePath,
    required this.name,
    required this.nickname,
    required this.phone,
    required this.onEdit,
  });

  final String imagePath;
  final String name;
  final String nickname;
  final String phone;
  final VoidCallback onEdit;

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
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              imagePath,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: Colors.black.withValues(alpha: 0.06),
                    alignment: Alignment.center,
                    child: const Icon(Icons.person, size: 28),
                  ),
            ),
          ),
          const SizedBox(width: 14),
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
                  '@$nickname  ·  $phone',
                  style: const TextStyle(fontSize: 13.5, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onEdit,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.items});
  final List<_InfoRow> items;

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
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(items[i].icon, size: 18),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 86,
                    child: Text(
                      items[i].label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      items[i].value,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                ],
              ),
            ),
            if (i != items.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _InfoRow {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
}
