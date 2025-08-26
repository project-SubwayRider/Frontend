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
  // 필드 컨트롤러
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

  bool _showPassword = false;

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
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.4),
      ),
    ),
  );

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> saveToCsv() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/profile_updated.csv'; // ✅ 문자열 보간 수정
      final file = File(path);

      final rows = <List<String>>[];
      for (final entry in controllers.entries) {
        rows.add([entry.key, entry.value.text]);
      }

      final csvData = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csvData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV 파일로 저장되었습니다!\n$path'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('저장 중 오류가 발생했습니다: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width >= 720 ? 28.0 : 18.0;

    return Theme(
      data: _monoTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text('환경설정')),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad, 10, pad, 14),
            child: FilledButton(
              onPressed: saveToCsv,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
              child: const Text('저장'),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(pad, 12, pad, 24),
          children: [
            _SectionTitle('계정'),
            const SizedBox(height: 8),
            _CardWrap(
              children: [
                _LabeledField(
                  label: '아이디',
                  controller: controllers['아이디']!,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                _LabeledField(
                  label: '비밀번호',
                  controller: controllers['비밀번호']!,
                  obscureText: !_showPassword,
                  suffix: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                    ),
                    onPressed:
                        () => setState(() => _showPassword = !_showPassword),
                  ),
                ),
                const SizedBox(height: 10),
                _LabeledField(label: '닉네임', controller: controllers['닉네임']!),
              ],
            ),

            const SizedBox(height: 16),
            _SectionTitle('개인 정보'),
            const SizedBox(height: 8),
            _CardWrap(
              children: [
                _LabeledField(
                  label: '생년월일',
                  controller: controllers['생년월일']!,
                  hint: '예: 1999-12-31',
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 10),
                _LabeledField(
                  label: '휴대전화번호',
                  controller: controllers['휴대전화번호']!,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                _LabeledField(
                  label: '매너온도',
                  controller: controllers['매너온도']!,
                  hint: '예: 36.5',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _SectionTitle('이동/주소'),
            const SizedBox(height: 8),
            _CardWrap(
              children: [
                _LabeledField(label: '출근역', controller: controllers['출근역']!),
                const SizedBox(height: 10),
                _LabeledField(label: '퇴근역', controller: controllers['퇴근역']!),
                const SizedBox(height: 10),
                _LabeledField(
                  label: '거주지 주소',
                  controller: controllers['거주지 주소']!,
                ),
              ],
            ),

            const SizedBox(height: 16),
            _SectionTitle('프로필'),
            const SizedBox(height: 8),
            _CardWrap(
              children: [
                _LabeledField(
                  label: '프로필 사진',
                  controller: controllers['프로필 사진']!,
                  hint: '이미지 경로 또는 URL',
                  prefix: const Icon(Icons.image_outlined, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────── Sub Widgets ───────────── */

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

class _CardWrap extends StatelessWidget {
  const _CardWrap({required this.children});
  final List<Widget> children;

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
      child: Column(children: children),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    this.hint,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
