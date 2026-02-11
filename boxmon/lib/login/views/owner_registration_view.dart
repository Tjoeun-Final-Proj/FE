import 'package:boxmon/core/design/app_design.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class OwnerRegistrationView extends GetView<AuthController> {
  OwnerRegistrationView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text(""), backgroundColor: Colors.white),
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
                  child: Text("차주용 회원가입", style: AppTextStyles.ownertag),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  controller: controller.emailController,
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

              SizedBox(height: 12),

              // 3. 비밀번호 입력창
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  controller: controller.passwordController,
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
              // 3. 비밀번호 입력창
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  obscureText: true, // 비밀번호 가리기
                  decoration: InputDecoration(
                    hintText: "비밀번호 확인하기",
                    hintStyle: AppTextStyles.hintbuttonText,
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
              SizedBox(height: 20),
              // 3. 비밀번호 입력창
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    hintText: "이름",
                    hintStyle: AppTextStyles.hintbuttonText,
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
              SizedBox(height: 20),
              // 3. 비밀번호 입력창
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  controller: controller.birthController,
                  decoration: InputDecoration(
                    hintText: "생년월일 8자리",
                    hintStyle: AppTextStyles.hintbuttonText,
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
              SizedBox(height: 20),
              // 3. 비밀번호 입력창
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(
                    hintText: "휴대전화 번호",
                    hintStyle: AppTextStyles.hintbuttonText,
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
              SizedBox(height: 20),
              // 3. 비밀번호 입력창
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  controller: controller.businessNumberController,
                  decoration: InputDecoration(
                    hintText: "사업자 번호",
                    hintStyle: AppTextStyles.hintbuttonText,
                    // 1. 아이콘 제약 조건 설정 (아이콘이 박스 안에서 차지하는 전체 너비)
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 70, // 아이콘 영역을 넓게 잡아서 자연스러운 패딩 효과
                    ),
                    prefixIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedUserList,
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
              // 3. 비밀번호 입력창
              Padding(
                padding: AppSpacing.paddingHorizontalHuge,
                child: TextField(
                  controller: controller.certNumberController,
                  decoration: InputDecoration(
                    hintText: "운수종사자 자격증 번호",
                    hintStyle: AppTextStyles.hintbuttonText,
                    // 1. 아이콘 제약 조건 설정 (아이콘이 박스 안에서 차지하는 전체 너비)
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 70, // 아이콘 영역을 넓게 잡아서 자연스러운 패딩 효과
                    ),
                    prefixIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedTaxi,
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
                    controller.driverSignup();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(55), // 높이만 설정

                    backgroundColor: AppColors.primary,
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
