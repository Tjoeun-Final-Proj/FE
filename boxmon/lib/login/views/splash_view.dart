import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _startAuthCheck(); // 실행!
  }

  Future<void> _startAuthCheck() async {
    // 1.5초 동안 로고 보여주기
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // AuthController의 함수 호출 (언더바 없음!)
    await _authController.checkAuthStatus(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/img/boxmon.png', height: 303, width: 338)), // 로딩 인디케이터
    );
  }
}
