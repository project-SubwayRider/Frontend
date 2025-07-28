import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, TextEditingController> controllers = {
    '아이디': TextEditingController(),
    '비밀번호': TextEditingController(),
    '닉네임': TextEditingController(),
    '생년월일': TextEditingController(),
    '출근역': TextEditingController(),
    '퇴근역': TextEditingController(),
    '매너온도': TextEditingController(),
    '휴대전화번호': TextEditingController(),
    '프로필 사진': TextEditingController(),
    '거주지 주소': TextEditingController(),
  };

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> saveToCsv() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('\${directory.path}/profile_updated.csv');
    final List<List<String>> rows = [];

    for (final entry in controllers.entries) {
      rows.add([entry.key, entry.value.text]);
    }

    final csvData = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csvData);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('CSV 파일로 저장되었습니다!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('환경설정')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            for (final entry in controllers.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: entry.key,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: saveToCsv, child: const Text('저장')),
          ],
        ),
      ),
    );
  }
}
