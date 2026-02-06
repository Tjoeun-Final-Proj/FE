import 'package:boxmon/core/app_design.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // ever(authController.isLoading, (bool loading) {
    //   if (!loading && Get.isDialogOpen!) {
    //     Get.back(); // 다이얼로그 닫기
    //   }
    // });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(""),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Image.asset('img/boxmon.png', height: 303, width: 338), 
              SizedBox(height: 50),
             
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.ownerLogin);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(55), // 높이만 설정
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.radiusLG,
                    ),
                  ),
                  child: const Text(
                    "차주로 계속하기",
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),
              const SizedBox(height: 20),
             Padding(
               padding: AppSpacing.paddingHorizontalHuge,
               child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(55), // 높이만 설정
                    backgroundColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.radiusLG,
                    ),
                  ),
                  child: const Text(
                    "화주로 계속하기",
                    style: AppTextStyles.buttonText,
                    ),
                  ),
             ),
              ],
            ),
          ),
      ), 
      );
  }
}