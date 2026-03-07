import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  // title 대신 로고를 쓸 것이므로 title 변수는 선택사항으로 변경하거나 제거해도 됩니다.
  final AuthController authController = Get.find<AuthController>();

  AppNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.10),
      centerTitle: false, // 로고를 왼쪽에 붙이기 위해 false
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFEDEDED)),
      ),
      // 1. 왼쪽 로고 설정
      title: Image.asset(
        'assets/img/logo.png', // 로고 이미지 경로
        height: 30, // 적절한 높이로 조절하세요
        fit: BoxFit.contain,
      ),

      // 2. 오른쪽 아이콘 버튼들 설정
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.commonAlarm),
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedNotification01, // 종 아이콘
            color: Colors.black,
            size: 28,
          ),
        ),
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.commonChatting),
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedTelegram, // 비행기 아이콘
            color: Colors.black,
            size: 28,
          ),
        ),
        const SizedBox(width: 10), // 오른쪽 끝 여백
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
