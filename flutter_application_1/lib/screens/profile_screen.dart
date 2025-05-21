import 'package:flutter/material.dart';
import '../data/profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = userProfile;

    return Scaffold(
      appBar: AppBar(title: const Text('회원정보')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            ClipOval(
              child: Image.asset(
                profile.profileImage,
                width: 140,
                height: 140,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 140,
                      height: 140,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, size: 50),
                    ),
              ),
            ),
            const SizedBox(height: 16),
            _buildItem('아이디', profile.id),
            _buildItem('이름', profile.name),
            _buildItem('닉네임', profile.nickname),
            _buildItem('비밀번호', profile.password),
            _buildItem('생년월일', profile.birthdate),
            _buildItem('출근역', profile.startStation),
            _buildItem('퇴근역', profile.endStation),
            _buildItem('매너온도', profile.mannerTemp),
            _buildItem('휴대전화번호', profile.phoneNumber),
            _buildItem('가입날짜', profile.joinDate),
            _buildItem('거주지주소', profile.address),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$title :',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
