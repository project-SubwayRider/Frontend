import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  String fileContent = '';

  @override
  void initState() {
    super.initState();
    loadFile();
  }

  Future<void> loadFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/delivery_requests.txt');

      debugPrint('📂 파일 경로: ${file.path}');

      if (await file.exists()) {
        final content = await file.readAsString();
        setState(() {
          fileContent = content;
        });
      } else {
        debugPrint('⚠️ 파일이 존재하지 않음');
        setState(() {
          fileContent = '저장된 배달 요청이 없습니다.';
        });
      }
    } catch (e, stack) {
      debugPrint('❌ 파일 읽기 오류: $e');
      debugPrint('📄 StackTrace:\n$stack');
      setState(() {
        fileContent = '파일을 불러오는 중 오류가 발생했습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배달 요청 목록')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(fileContent, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
