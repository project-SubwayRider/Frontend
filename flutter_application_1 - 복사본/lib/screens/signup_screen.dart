import 'package:flutter/material.dart';
import '../data/users.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();
  final birthController = TextEditingController();
  final fromStationController = TextEditingController();
  final toStationController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final profileImageController = TextEditingController();

  void registerUser() {
    final newUser = User(
      id: idController.text,
      name: nameController.text,
      nickname: nicknameController.text,
      password: passwordController.text,
      birth: birthController.text,
      startStation: fromStationController.text,
      endStation: toStationController.text,
      phone: phoneController.text,
      imagePath: 'assets/profile.jpg',
      address: addressController.text,
    );

    userList.add(newUser);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('회원가입이 완료되었습니다.')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildTextField('아이디', idController),
            buildTextField('이름', nameController),
            buildTextField('닉네임', nicknameController),
            buildTextField('비밀번호', passwordController, obscure: true),
            buildTextField('생년월일', birthController),
            buildTextField('출근역', fromStationController),
            buildTextField('퇴근역', toStationController),
            buildTextField('휴대전화번호', phoneController),
            buildTextField('거주지 주소', addressController),
            buildTextField('프로필 이미지 URL/경로', profileImageController),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: registerUser, child: const Text('가입 완료')),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
