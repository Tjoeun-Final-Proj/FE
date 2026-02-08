import 'package:boxmon/core/design/app_design.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class AuthMainView extends StatelessWidget {
  const AuthMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   title: Text(""),
      // ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedUser,
                color: Colors.grey[600],
              ),
              Image.asset('img/boxmon.png', height: 313, width: 338),
              SizedBox(height: 50),

              // 위브 버튼
              ElevatedButton(
                onPressed: onPressedWeave,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(55), // 높이만 설정
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.radiusLG,
                  ),
                ),
                child: const Text("시작하기", style: AppTextStyles.buttonText),
              ),

              SizedBox(height: 20),

              // ElevatedButton(
              //   onPressed: onPressedOwner,
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: Size.fromHeight(55), // 높이만 설정
              //     backgroundColor: Color(0xFF434343),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //   ),
              //   child: Text(
              //     "오너로 계속하기",
              //     style: TextStyle(
              //       fontSize: 24,
              //       fontWeight: FontWeight.w700,
              //       color: Colors.white,
              //       fontFamily: 'Pretendard',
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressedWeave() {
    Get.toNamed(AppRoutes.login);
  }

  void onPressedOwner() {
    Get.toNamed(AppRoutes.ownerLogin);
  }
}
