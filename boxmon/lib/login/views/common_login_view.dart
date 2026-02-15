import 'package:boxmon/core/design/app_design.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class LoginView extends StatelessWidget {
  // 컨트롤러는 Get.find로 가져옵니다.
  // (email/passwordController는 AuthController 안에 있는 것을 사용하는 것이 데이터 관리에 더 좋습니다.)
  final AuthController authController = Get.find<AuthController>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(""),
      ),
      body: Center(
        child: SingleChildScrollView(
          // 키보드가 올라올 때 대비하여 추가
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/img/logo.png', height: 97, width: 330),
                const SizedBox(height: 20),

                // "화주 계정" 라벨
                Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("화주 계정", style: AppTextStyles.usertag),
                  ),
                ),
                const SizedBox(height: 10),

                // 1. 아이디 입력창
                Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: Obx(
                    () => TextField(
                      controller: authController.emailController,
                      decoration: InputDecoration(
                        hintText: "아이디",
                        hintStyle: AppTextStyles.hintbuttonText,
                        // 에러 메시지 표시
                        errorText: authController.emailError.value.isEmpty
                            ? null
                            : authController.emailError.value,
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 70,
                        ),
                        prefixIcon: HugeIcon(
                          icon: HugeIcons.strokeRoundedUserCircle02,
                          color: Colors.grey[600],
                          size: 33.0,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1D1D1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1D1D1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 2. 비밀번호 입력창
                Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: Obx(
                    () => TextField(
                      controller: authController.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "비밀번호",
                        hintStyle: AppTextStyles.hintbuttonText,
                        // 에러 메시지 표시
                        errorText: authController.passwordError.value.isEmpty
                            ? null
                            : authController.passwordError.value,
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 70,
                        ),
                        prefixIcon: HugeIcon(
                          icon: HugeIcons.strokeRoundedCircleLock01,
                          color: Colors.grey[600],
                          size: 33.0,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1D1D1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFD1D1D1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. 로그인 버튼
                Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : () {
                              authController.login(
                                authController.emailController.text.trim(),
                                authController.passwordController.text.trim(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        backgroundColor: AppColors.primaryLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.radiusLG,
                        ),
                      ),
                      child: authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text("로그인하기", style: AppTextStyles.buttonText),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 4. 하단 버튼 (회원가입 / 비밀번호 찾기)
                Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.register),
                            child: Text(
                              "회원가입 하기",
                              style: AppTextStyles.bodyMediumBold.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(width: 1, color: Colors.black),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "비밀번호 찾기",
                              style: AppTextStyles.bodyMediumBold.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
