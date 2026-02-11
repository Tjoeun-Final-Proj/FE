import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

// 오너 미들웨어고 드라이버인지 체크해서 리다이렉트
class OwnerMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    authController.checkIsDriver();
    if (route == AppRoutes.ownerOrder) {
      if (authController.isDriver.value) {
        if (kIsWeb) {
          Get.snackbar("오류", "웹브라우저에서 지원하지 않는 기능입니다.");
          return const RouteSettings(name: AppRoutes.ownerHome);
        } else {
          return const RouteSettings(name: AppRoutes.ownerSetting);
        }
      } else {
        return null;
      }
    }
    // if (route == AppRoutes.REWARDS) {
    //   if (authController.isOwner.value) {
    //     return const RouteSettings(name: AppRoutes.OWNER_REWARDS);
    //   } else {
    //     return null;
    //   }
    // }
    return null; // 기본적으로 리다이렉트하지 않음
  }
}