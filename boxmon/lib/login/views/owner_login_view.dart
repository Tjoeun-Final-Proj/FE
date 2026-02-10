import 'package:boxmon/core/design/app_design.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/auth_controller.dart';

class OwnerLoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  OwnerLoginView({super.key});

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
              Image.asset('assets/img/logo.png', height: 97, width: 330),
              SizedBox(height: 20),
              // 1. 차주 계정 타이틀
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("차주 계정", style: AppTextStyles.ownertag),
                ),
              ),

              const SizedBox(height: 10),

              // 2. 아이디 입력창
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "아이디",
                    hintStyle: AppTextStyles.hintbuttonText,
                    // 1. 아이콘 제약 조건 설정 (아이콘이 박스 안에서 차지하는 전체 너비)
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 70, // 아이콘 영역을 넓게 잡아서 자연스러운 패딩 효과
                    ),
                    prefixIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedUserCircle02,
                      color: Colors.grey[600],
                      size: 33.0,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    // 기본 테두리 (둥글게)
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFD1D1D1)),
                    ),
                    // 선택되지 않았을 때 테두리
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFD1D1D1)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 3. 비밀번호 입력창
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  obscureText: true, // 비밀번호 가리기
                  decoration: InputDecoration(
                    hintText: "비밀번호",
                    hintStyle: AppTextStyles.hintbuttonText,
                    // 1. 아이콘 제약 조건 설정 (아이콘이 박스 안에서 차지하는 전체 너비)
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 70, // 아이콘 영역을 넓게 잡아서 자연스러운 패딩 효과
                    ),
                    prefixIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedCircleLock01,
                      color: Colors.grey[600],
                      size: 33.0,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFD1D1D1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFFD1D1D1)),
                    ),
                  ),
                ),
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

                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.radiusLG,
                    ),
                  ),
                  child: Text("로그인하기", style: AppTextStyles.buttonText),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: IntrinsicHeight(
                  // 자식들(텍스트와 선)의 높이를 통일시킵니다.
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    children: [
                      // 회원가입 하기 버튼
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.ownerRegister);
                          },
                          child: Text(
                            "회원가입 하기",
                            style: AppTextStyles.bodyMediumBold.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // 중간 수직 구분선
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ), // 선의 위아래 여백
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
    );
  }
}
