import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../screens/delivery_screen.dart'; // DeliveryData import

Future<void> saveRequestToFile(DeliveryData data) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/delivery_requests.txt');

    final content = """
[배달 요청]
- 어디서: ${data.from}
- 어디로: ${data.to}
- 음식: ${data.food}
- 시간: ${data.time}
- 요청 사항: ${data.memo}
-------------------------------
""";

    await file.writeAsString(content, mode: FileMode.append);
  } catch (e, stack) {
    debugPrint('파일 저장 중 오류 발생: $e');
    debugPrint('StackTrace: $stack');
  }
}
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import '../screens/delivery_screen.dart'; // DeliveryData

// Future<void> saveRequestToFile(DeliveryData data) async {
//   try {
//     // ✅ PC 환경에서 Documents 폴더 경로로 직접 지정
//     final directory = Directory(
//       Platform.isWindows
//           ? '${Platform.environment['USERPROFILE']}\\Documents'
//           : '${Platform.environment['HOME']}/Documents',
//     );

//     final file = File('${directory.path}/delivery_requests.txt');

//     final content = """
// [배달 요청]
// - 어디서: ${data.from}
// - 어디로: ${data.to}
// - 음식: ${data.food}
// - 시간: ${data.time}
// - 요청 사항: ${data.memo}
// -------------------------------
// """;

//     await file.writeAsString(content, mode: FileMode.append);

//     debugPrint('📄 저장 완료! 경로: ${file.path}');
//   } catch (e, stack) {
//     debugPrint('❌ 파일 저장 중 오류: $e');
//     debugPrint('📄 StackTrace:\n$stack');
//   }
// }
