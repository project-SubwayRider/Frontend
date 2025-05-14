import 'package:flutter/material.dart';
import 'data/options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadLocationsFromCsv();
  runApp(const DeliveryFormApp());
}

class DeliveryFormApp extends StatelessWidget {
  const DeliveryFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: Scaffold(body: Center(child: DeliveryForm())),
    );
  }
}

class DeliveryForm extends StatefulWidget {
  const DeliveryForm({super.key});

  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  String? from;
  String? to;
  String? time;
  String? food;

  final TextEditingController _foodController = TextEditingController();

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(locations),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildAutocompleteRow(
                '어디서',
                from,
                snapshot.data!,
                (val) => setState(() => from = val),
              ),
              const SizedBox(height: 16),
              buildAutocompleteRow(
                '어디로',
                to,
                snapshot.data!,
                (val) => setState(() => to = val),
              ),
              const SizedBox(height: 16),
              buildTextFieldRow('무슨 음식', _foodController),
              const SizedBox(height: 16),
              buildAutocompleteRow(
                '언제',
                time,
                times,
                (val) => setState(() => time = val),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final partialData = DeliveryData(
                    from: from ?? '',
                    to: to ?? '',
                    food: _foodController.text,
                    time: time ?? '',
                    memo: '', // 일단 빈 값
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemoScreen(data: partialData),
                    ),
                  );
                },
                child: const Text('다음'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildAutocompleteRow(
    String label,
    String? selectedValue,
    List<String> options,
    ValueChanged<String> onSelected,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 24)),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldRow(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              hintText: '입력하세요',
            ),
            onChanged: (val) => setState(() => food = val),
          ),
        ),
      ],
    );
  }
}

class MemoScreen extends StatelessWidget {
  final DeliveryData data;
  const MemoScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final TextEditingController memoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('글 입력')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              '배달자가 필요한 내용을 자세히 입력해 주세요!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: memoController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '여기에 입력...',
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final updatedData = data.copyWith(memo: memoController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(data: updatedData),
                  ),
                );
              },
              child: const Text('입력 완료'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final DeliveryData data;
  const ResultScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('입력 내용 확인')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    '🚉 어디서: ${data.from}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '🏁 어디로: ${data.to}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '🍙 음식: ${data.food}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '🕒 시간: ${data.time}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    '📝 글',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(data.memo, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('글을 올릴까요?', style: TextStyle(fontSize: 18)),
                ElevatedButton(onPressed: () {}, child: const Text('올리기')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    required this.memo,
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
