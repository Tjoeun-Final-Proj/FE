import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/common_bottom_navigation.dart';
import 'package:boxmon/core/design/app_design.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonSettingView extends StatelessWidget {
  CommonSettingView({super.key});

  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(),
      body: Row(
        children: [
          Text("Hello 나는 공통 설정이야"),
          Expanded(
            child: TextButton(
              onPressed: () {
                authController.userlogout();
              },
              child: Text(
                "로그아웃 하기",
                style: AppTextStyles.bodyMediumBold.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
      // 속성 이름을 bottomNavigationBar로 수정하세요!
      bottomNavigationBar: CommonBottomNavigation(currentIndex: 2),
    );
  }
}
