import 'package:boxmon/core/design/app_design.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class RegistrationView extends GetView<AuthController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(""),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // 스크롤 시 튕기는 효과 (iOS 스타일)
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset('assets/img/logo.png', height: 97, width: 330),
              SizedBox(height: 20),
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("화주용 회원가입", style: AppTextStyles.usertag),
                ),
              ),
              Obx(
                () => Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: TextField(
                    controller: controller.emailController,
                    style: AppTextStyles.realText,
                    decoration: InputDecoration(
                      isDense: true, // 1. 내부 밀도 고정
                      hintText: "아이디",
                      hintStyle: AppTextStyles.hintbuttonText,
                      // 2. 에러가 없을 때도 한 줄 공간 확보 (입력창 크기 고정 핵심!)
                      helperText: controller.emailError.value.isEmpty
                          ? " "
                          : null,
                      errorText: controller.emailError.value.isEmpty
                          ? null
                          : controller.emailError.value,
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
              ),

              // 3. 비밀번호 입력창
              Obx(
                () => Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: TextField(
                    controller: controller.passwordController,
                    style: AppTextStyles.realText,
                    obscureText: true, // 비밀번호 가리기
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "비밀번호",
                      hintStyle: AppTextStyles.hintbuttonText,
                      helperText: controller.emailError.value.isEmpty
                          ? " "
                          : null,
                      errorText: controller.passwordError.value.isEmpty
                          ? null
                          : controller.passwordError.value,
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
              ),
              // 3. 비밀번호 입력창
              Obx(
                () => Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: TextField(
                    controller: controller.confirmPasswordController,
                    style: AppTextStyles.realText,
                    obscureText: true, // 비밀번호 가리기
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "비밀번호 확인하기",
                      hintStyle: AppTextStyles.hintbuttonText,
                      helperText: controller.confirmPasswordError.value.isEmpty
                          ? " "
                          : null,
                      errorText: controller.confirmPasswordError.value.isEmpty
                          ? null
                          : controller.confirmPasswordError.value,
                      // 1. 아이콘 제약 조건 설정 (아이콘이 박스 안에서 차지하는 전체 너비)
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 70, // 아이콘 영역을 넓게 잡아서 자연스러운 패딩 효과
                      ),
                      prefixIcon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCircleLockCheck02,
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
              ),
              // 3. 이름 입력창
              Obx(
                () => Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: TextField(
                    controller: controller.nameController,
                    style: AppTextStyles.realText,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "이름",
                      hintStyle: AppTextStyles.hintbuttonText,
                      helperText: controller.nameError.value.isEmpty
                          ? " "
                          : null,
                      errorText: controller.nameError.value.isEmpty
                          ? null
                          : controller.nameError.value,
                      // 1. 아이콘 제약 조건 설정 (아이콘이 박스 안에서 차지하는 전체 너비)
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 70, // 아이콘 영역을 넓게 잡아서 자연스러운 패딩 효과
                      ),
                      prefixIcon: HugeIcon(
                        icon: HugeIcons.strokeRoundedUser,
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
              ),
              // 3. 생년월일 입력창
              Obx(
                () => Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: TextField(
                    controller: controller.birthController,
                    style: AppTextStyles.realText,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 허용
                      controller.birthFormatter, // 컨트롤러에 있는 거 그대로 사용
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "생년월일 8자리",
                      hintStyle: AppTextStyles.hintbuttonText,
                      helperText: controller.birthError.value.isEmpty
                          ? " "
                          : null,
                      errorText: controller.birthError.value.isEmpty
                          ? null
                          : controller.birthError.value,
                      // 1. 아이콘 제약 조건 설정 (아이콘이 박스 안에서 차지하는 전체 너비)
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 70, // 아이콘 영역을 넓게 잡아서 자연스러운 패딩 효과
                      ),
                      prefixIcon: HugeIcon(
                        icon: HugeIcons.strokeRoundedUserIdVerification,
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
              ),
              // 3. 휴대폰 입력 창
              Obx(
                () => Padding(
                  padding: AppSpacing.paddingHorizontalHuge,
                  child: TextField(
                    controller: controller.phoneController,
                    style: AppTextStyles.realText,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "휴대전화 번호",
                      hintStyle: AppTextStyles.hintbuttonText,
                      helperText: controller.phoneError.value.isEmpty
                          ? " "
                          : null,
                      errorText: controller.phoneError.value.isEmpty
                          ? null
                          : controller.phoneError.value,
                      // 1. 아이콘 제약 조건 설정 (아이콘이 박스 안에서 차지하는 전체 너비)
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 70, // 아이콘 영역을 넓게 잡아서 자연스러운 패딩 효과
                      ),
                      prefixIcon: HugeIcon(
                        icon: HugeIcons.strokeRoundedSmartPhone02,
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
              ),

              // 로그인 버튼
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: ElevatedButton(
                  onPressed: () {
                    controller.commonSignup1();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(55), // 높이만 설정

                    backgroundColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.radiusLG,
                    ),
                  ),
                  child: Text("회원가입 하기", style: AppTextStyles.buttonText),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
