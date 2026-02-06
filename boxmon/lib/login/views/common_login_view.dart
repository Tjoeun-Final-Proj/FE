import 'package:boxmon/core/app_design.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
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
                Image.asset('img/logo.png', height: 97, width: 330), 
                SizedBox(height: 20),
                Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "아이디")),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: "비밀번호"),
                      obscureText: true),
                ),
                SizedBox(height: 20),

                // 로그인 버튼
                Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: ElevatedButton(
                    onPressed: () {
                      // authController.login(
                      //     emailController.text, passwordController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(55), // 높이만 설정
                      
                    backgroundColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.radiusLG,
                    ),
                    ),
                    child: Text(
                      "로그인하기",
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: IntrinsicHeight( // 자식들(텍스트와 선)의 높이를 통일시킵니다.
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                      children: [
                        // 회원가입 하기 버튼
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.register);
                            },
                            child: Text(
                              "회원가입 하기",
                              style: AppTextStyles.bodyMediumBold.copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                        
                        // 중간 수직 구분선
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0), // 선의 위아래 여백
                          child: Container(
                            width: 1, // 선 두께
                            color: Colors.black, // 선 색상
                          ),
                        ),

                        // 비밀번호 찾기 버튼
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "비밀번호 찾기",
                              style: AppTextStyles.bodyMediumBold.copyWith(color: Colors.black),
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
      );
  }
}