import 'package:flutter/material.dart';
import '../data/options.dart';
import '../utils/save_file_util.dart';

// 📦 데이터 모델
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

  DeliveryData copyWith({String? memo}) {
    return DeliveryData(
      from: from,
      to: to,
      food: food,
      time: time,
      memo: memo ?? this.memo,
    );
  }
}

// 🚚 입력 화면
class DeliveryFormScreen extends StatefulWidget {
  const DeliveryFormScreen({super.key});

  @override
  State<DeliveryFormScreen> createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryFormScreen> {
  String? from;
  String? to;
  String? food;
  String? time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배달 입력')),
      body: FutureBuilder(
        future: Future.value(locations),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildRow(
                  '어디서',
                  locations,
                  from,
                  (val) => setState(() => from = val),
                ),
                const SizedBox(height: 16),
                buildRow(
                  '어디로',
                  locations,
                  to,
                  (val) => setState(() => to = val),
                ),
                const SizedBox(height: 16),
                buildTextFieldRow('무슨 음식'),
                const SizedBox(height: 16),
                buildRow(
                  '언제',
                  times,
                  time,
                  (val) => setState(() => time = val),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (from != null &&
                        to != null &&
                        food != null &&
                        time != null) {
                      final data = DeliveryData(
                        from: from!,
                        to: to!,
                        food: food!,
                        time: time!,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemoScreen(data: data),
                        ),
                      );
                    }
                  },
                  child: const Text('다음'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildRow(
    String label,
    List<String> options,
    String? selectedValue,
    ValueChanged<String> onSelected,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 16),
        Expanded(
          child: Autocomplete<String>(
            initialValue: TextEditingValue(text: selectedValue ?? ''),
            optionsBuilder: (TextEditingValue textEditingValue) {
              return options
                  .where((option) => option.contains(textEditingValue.text))
                  .toList();
            },
            onSelected: onSelected,
            fieldViewBuilder: (
              context,
              controller,
              focusNode,
              onFieldSubmitted,
            ) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldRow(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            onChanged: (val) => setState(() => food = val),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              hintText: '음식을 입력하세요',
            ),
          ),
        ),
      ],
    );
  }
}

// ✍️ 메모 작성 화면
class MemoScreen extends StatelessWidget {
  final DeliveryData data;
  const MemoScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final TextEditingController memoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('배달 요청 입력')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🚉 어디서: ${data.from}', style: const TextStyle(fontSize: 18)),
            Text('🏁 어디로: ${data.to}', style: const TextStyle(fontSize: 18)),
            Text('🍱 음식: ${data.food}', style: const TextStyle(fontSize: 18)),
            Text('🕒 시간: ${data.time}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            const Text(
              '📝 요청 사항',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: memoController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '여기에 배달 요청 사항을 적어주세요...',
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final updated = data.copyWith(memo: memoController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(data: updated),
                  ),
                );
              },
              child: const Text('요청 완료'),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ 요청 확인 화면 (StatefulWidget로 수정)
class ResultScreen extends StatefulWidget {
  final DeliveryData data;
  const ResultScreen({super.key, required this.data});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('요청 확인')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('정말 요청하시겠습니까?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Text(
              '🚉 어디서: ${widget.data.from}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '🏁 어디로: ${widget.data.to}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '🍱 음식: ${widget.data.food}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '🕒 시간: ${widget.data.time}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              '📝 요청 사항',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.data.memo, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('뒤로가기'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await saveRequestToFile(widget.data);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('배달 요청이 저장되었습니다!')),
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('요청하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
