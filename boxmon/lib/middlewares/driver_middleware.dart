import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

// 오너 미들웨어고 드라이버인지 체크해서 리다이렉트
class DriverMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    authController.checkIsDriver();
    // Service는 앱 실행 시점에 이미 init되어 있으므로 데이터를 즉시 꺼낼 수 있습니다.
    final tokenService = Get.find<TokenService>();

    // 오너 페이지(ownerOrder)에 접근하려고 할 때
    if (route == AppRoutes.ownerOrder) {
      // 만약 유저 타입이 DRIVER라면 (오너가 아니라면)
      if (tokenService.userType == "DRIVER") { 
        if (kIsWeb) {
          print("당신은 드라이버군요! 오너 페이지 접근을 제한합니다.");
          // 참고: redirect 내부에서 snackbar를 띄우면 화면 전환과 겹쳐서 제대로 안 보일 수 있습니다.
          return const RouteSettings(name: AppRoutes.ownerHome);
        } else {
          return null;
        }
      }
    }
    return null; // 조건에 걸리지 않으면 원래 가려던 곳으로 보냄
  }
}