import 'package:flutter/material.dart';
import '../data/options.dart'; // locations, times
import '../utils/save_file_util.dart'; // saveRequestToFile()

/// 🔳 공통 모노톤 테마 (화이트 + 블랙)
final ThemeData monoTheme = ThemeData(
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
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 1.4),
      borderRadius: BorderRadius.circular(12),
    ),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.black, width: 1.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

/// 📦 데이터 모델
class DeliveryData {
  final String from;
  final String to;
  final String food;
  final String time;
  final String memo;
  DeliveryData({
    required this.from,
    required this.to,
    required this.food,
    required this.time,
    this.memo = '',
  });
  DeliveryData copyWith({String? memo}) => DeliveryData(
    from: from,
    to: to,
    food: food,
    time: time,
    memo: memo ?? this.memo,
  );
}

/// ─────────────────────────────────────────────────────────────────────────
/// 1) 배달 입력 화면
class DeliveryFormScreen extends StatefulWidget {
  const DeliveryFormScreen({super.key});
  @override
  State<DeliveryFormScreen> createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? from, to, time, food;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width >= 720 ? 28.0 : 18.0;

    return Theme(
      data: monoTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text('배달 입력')),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.fromLTRB(pad, 10, pad, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
              ),
            ),
            child: FilledButton(
              onPressed: _canNext ? _goNext : null,
              child: const Text('다음'),
            ),
          ),
        ),
        body: FutureBuilder<List<String>>(
          future: Future.value(locations),
          builder: (context, snap) {
            if (!snap.hasData || snap.data!.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(pad, 10, pad, 24),
              child: Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _StepHeader(current: 1, total: 3),
                    const SizedBox(height: 18),

                    _AutocompleteField(
                      label: '어디서',
                      hint: '출발지를 입력하세요',
                      initial: from,
                      options: snap.data!,
                      prefixIcon: const Icon(Icons.place_outlined),
                      validator:
                          (v) => (v == null || v.isEmpty) ? '출발지를 입력하세요' : null,
                      onSelected: (v) => setState(() => from = v),
                      onChanged: (v) => setState(() => from = v),
                    ),
                    const SizedBox(height: 14),

                    _AutocompleteField(
                      label: '어디로',
                      hint: '도착지를 입력하세요',
                      initial: to,
                      options: snap.data!,
                      prefixIcon: const Icon(Icons.flag_outlined),
                      validator:
                          (v) => (v == null || v.isEmpty) ? '도착지를 입력하세요' : null,
                      onSelected: (v) => setState(() => to = v),
                      onChanged: (v) => setState(() => to = v),
                    ),
                    const SizedBox(height: 14),

                    _TextBoxField(
                      label: '무슨 음식',
                      hint: '음식을 입력하세요',
                      prefixIcon: const Icon(Icons.restaurant_outlined),
                      initial: food,
                      validator:
                          (v) => (v == null || v.isEmpty) ? '음식을 입력하세요' : null,
                      onChanged: (v) => setState(() => food = v),
                    ),
                    const SizedBox(height: 14),

                    _DropdownField(
                      label: '언제',
                      value: time,
                      items: times,
                      prefixIcon: const Icon(Icons.access_time),
                      validator: (v) => v == null ? '시간을 선택하세요' : null,
                      onChanged: (v) => setState(() => time = v),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool get _canNext => _formKey.currentState?.validate() ?? false;

  void _goNext() {
    if (!_canNext) return;
    final data = DeliveryData(from: from!, to: to!, food: food!, time: time!);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MemoScreen(data: data)),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────
/// 2) 메모 화면
class MemoScreen extends StatefulWidget {
  final DeliveryData data;
  const MemoScreen({super.key, required this.data});
  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width >= 720 ? 28.0 : 18.0;
    return Theme(
      data: monoTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text('배달 요청 입력')),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.fromLTRB(pad, 10, pad, 14),
            child: FilledButton(
              onPressed: () {
                final updated = widget.data.copyWith(
                  memo: _controller.text.trim(),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultScreen(data: updated),
                  ),
                );
              },
              child: const Text('확인으로 이동'),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(pad, 10, pad, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StepHeader(current: 2, total: 3),
              const SizedBox(height: 18),
              _SummaryCard(data: widget.data),
              const SizedBox(height: 18),
              const Text(
                '요청 사항',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: '예) 소스 따로, 매운맛 X, 도착 전에 전화 주세요 등',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────
/// 3) 확인 화면
class ResultScreen extends StatefulWidget {
  final DeliveryData data;
  const ResultScreen({super.key, required this.data});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width >= 720 ? 28.0 : 18.0;
    return Theme(
      data: monoTheme,
      child: Scaffold(
        appBar: AppBar(title: const Text('요청 확인')),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(pad, 10, pad, 14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: const Text('수정하기'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _submit,
                    child:
                        _saving
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                            : const Text('요청하기'),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(pad, 10, pad, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StepHeader(current: 3, total: 3),
              const SizedBox(height: 18),
              _SummaryCard(data: widget.data),
              const SizedBox(height: 16),
              const Text(
                '요청 사항',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                  color: Colors.black.withValues(alpha: 0.02),
                ),
                child: Text(
                  widget.data.memo.isEmpty ? '작성된 메모가 없습니다.' : widget.data.memo,
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    await saveRequestToFile(widget.data);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('배달 요청이 저장되었습니다!')));
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}

/// ─────────────────────────────────────────────────────────────────────────
/// 공용 위젯들
class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.current, required this.total});
  final int current;
  final int total;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = (i + 1) == current;
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
            decoration: BoxDecoration(
              color:
                  active ? Colors.black : Colors.black.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      }),
    );
  }
}

/// 깔끔한 요약 카드 (보라 배경 제거 + 라벨/값 정렬)
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});
  final DeliveryData data;

  @override
  Widget build(BuildContext context) {
    Widget row(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            SizedBox(
              width: 64,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(value, style: const TextStyle(fontSize: 15.0)),
            ),
          ],
        ),
      );
    }

    return Container(
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
      child: Column(
        children: [
          row(Icons.place_outlined, '어디서', data.from),
          const Divider(height: 1),
          row(Icons.flag_outlined, '어디로', data.to),
          const Divider(height: 1),
          row(Icons.restaurant_outlined, '무슨 음식', data.food),
          const Divider(height: 1),
          row(Icons.access_time, '언제', data.time),
        ],
      ),
    );
  }
}

class _AutocompleteField extends StatelessWidget {
  const _AutocompleteField({
    required this.label,
    required this.hint,
    required this.options,
    required this.onSelected,
    required this.onChanged,
    this.prefixIcon,
    this.validator,
    this.initial,
  });

  final String label;
  final String hint;
  final List<String> options;
  final void Function(String) onSelected;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final String? initial;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Autocomplete<String>(
          initialValue: TextEditingValue(text: initial ?? ''),
          optionsBuilder: (TextEditingValue tev) {
            final q = tev.text.trim();
            if (q.isEmpty) return const Iterable<String>.empty();
            return options.where((o) => o.contains(q));
          },
          onSelected: onSelected,
          fieldViewBuilder: (context, controller, focusNode, _) {
            controller.addListener(() => onChanged(controller.text));
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              validator: validator,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: prefixIcon,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TextBoxField extends StatelessWidget {
  const _TextBoxField({
    required this.label,
    required this.hint,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.initial,
  });
  final String label;
  final String hint;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final String? initial;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initial,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(hintText: hint, prefixIcon: prefixIcon),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.prefixIcon,
  });
  final String label;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? value;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          validator: validator,
          isExpanded: true,
          onChanged: onChanged,
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.black,
          decoration: InputDecoration(prefixIcon: prefixIcon),
          items:
              items
                  .map(
                    (t) => DropdownMenuItem<String>(
                      value: t,
                      child: Text(
                        t,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
