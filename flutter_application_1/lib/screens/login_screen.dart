import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 상태바 스타일 설정용
import '../data/users.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final _idFocus = FocusNode();
  final _pwFocus = FocusNode();

  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    _idFocus.dispose();
    _pwFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => _loading = true);
    try {
      final id = idController.text.trim();
      final pw = passwordController.text;

      final user = userList.firstWhere(
        (u) => u.id == id && u.password == pw,
        orElse: () => User.empty(),
      );

      if (!mounted) return;

      if (user.id.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        _showError('아이디 또는 비밀번호가 일치하지 않습니다.');
      }
    } catch (_) {
      _showError('로그인 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0x1F000000)),
          borderRadius: BorderRadius.circular(12),
        ),
        content: Text(msg, style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 하얀색
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경 하얀색
        foregroundColor: Colors.black, // 아이콘/텍스트 검정
        elevation: 0.5,
        centerTitle: true, // 제목 가운데 정렬
        title: const Text('로그인'),
        leading: const BackButton(color: Colors.black),
        surfaceTintColor: Colors.white, // M3 틴트 제거
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // Android 상태바 배경
          statusBarIconBrightness: Brightness.dark, // Android 상태바 아이콘 검정
          statusBarBrightness: Brightness.light, // iOS에서 상태바 아이콘 검정
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                color: Colors.white, // 카드 화이트
                elevation: 0,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0x14000000)), // 은은한 테두리
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            '대중 교통으로 만드는 특별한 배달!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '서브웨이 라이더',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '아이디와 비밀번호를 입력해 주세요.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ID
                          TextFormField(
                            controller: idController,
                            focusNode: _idFocus,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.username],
                            decoration: InputDecoration(
                              labelText: '아이디',
                              hintText: '아이디를 입력해 주세요',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                              ),
                              hintStyle: const TextStyle(color: Colors.black38),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.black54,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: _border(const Color(0x22000000)),
                              enabledBorder: _border(const Color(0x22000000)),
                              focusedBorder: _border(Colors.black87),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (v) {
                              final t = (v ?? '').trim();
                              if (t.isEmpty) return '아이디를 입력해 주세요';
                              if (t.length < 3) return '아이디는 3자 이상이어야 합니다';
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_pwFocus);
                            },
                          ),
                          const SizedBox(height: 14),

                          // PASSWORD
                          TextFormField(
                            controller: passwordController,
                            focusNode: _pwFocus,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: '비밀번호',
                              hintText: '비밀번호를 입력해 주세요',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                              ),
                              hintStyle: const TextStyle(color: Colors.black38),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.black54,
                              ),
                              suffixIcon: IconButton(
                                onPressed:
                                    () => setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black54,
                                ),
                                tooltip: _obscure ? '비밀번호 보기' : '비밀번호 숨기기',
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: _border(const Color(0x22000000)),
                              enabledBorder: _border(const Color(0x22000000)),
                              focusedBorder: _border(Colors.black87),
                            ),
                            style: const TextStyle(color: Colors.black),
                            validator: (v) {
                              final t = (v ?? '');
                              if (t.isEmpty) return '비밀번호를 입력해 주세요';
                              if (t.length < 4) return '비밀번호는 4자 이상이어야 합니다';
                              return null;
                            },
                            onFieldSubmitted: (_) => _login(),
                          ),
                          const SizedBox(height: 20),

                          // 로그인 버튼 (화이트)
                          SizedBox(
                            height: 48,
                            child: FilledButton(
                              onPressed: _loading ? null : _login,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color(0x1F000000),
                                  ),
                                ),
                              ),
                              child:
                                  _loading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
                                      )
                                      : const Text('로그인'),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // 회원가입
                          TextButton(
                            onPressed:
                                _loading
                                    ? null
                                    : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const SignUpScreen(),
                                        ),
                                      );
                                    },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                            ),
                            child: const Text('회원가입'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
