import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/owner_bottom_navigation.dart';
import 'package:boxmon/core/design/app_design.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerSettingView extends StatelessWidget {
  OwnerSettingView({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavBar(), // 상단 로고 및 아이콘
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // --- 프로필 섹션 ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "관리자님",
                      style: AppTextStyles.bodyLargeBold.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "010-1234-1234",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 상단 버튼 2개 (결제 관리 / 내 쿠폰) ---
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0047AB), // 박스몬 블루
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "결제 관리",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "내 쿠폰",
                        style: TextStyle(
                          color: Color(0xFF0047AB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 이벤트 배너 ---
            Center(
              // 센터 정렬
              child: Container(
                width: double.infinity, // 가로를 꽉 채웁니다
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ), // 상하 여백 필요시 조절
                child: ClipRRect(
                  // 모서리를 둥글게 하고 싶을 때 사용 (이미지와 동일하게)
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/img/ad.boxmon.png',
                    // height: 200, // 높이를 고정하면 이미지가 찌그러질 수 있으니 주의!
                    fit: BoxFit.fitWidth, // 가로 길이에 맞춰서 비율대로 채움
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // --- 운송목적 선택 섹션 ---
            Text(
              "계좌 등록하기",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
  onTap: () => _showAccountDialog(), // 다이얼로그 호출
  leading: const Icon(Icons.money, color: Colors.black),
  title: const Text(
    "계좌 등록",
    style: TextStyle(fontWeight: FontWeight.w500),
  ),
  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
),
            ),
            const SizedBox(height: 32),

            // --- 더보기 섹션 ---
            Text(
              "더보기",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...["공지사항", "고객센터", "시스템 설정"].map((title) {
              IconData icon;
              if (title == "공지사항")
                icon = Icons.check_circle_outline;
              else if (title == "고객센터")
                icon = Icons.headset_mic_outlined;
              else
                icon = Icons.settings_outlined;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(icon, color: Colors.black),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // 메뉴 클릭 로직
                  },
                ),
              );
            }),

            const SizedBox(height: 40),

            // --- 로그아웃 하기 버튼 ---
            Center(
              child: TextButton(
                onPressed: () {
                  authController.userlogout();
                },
                child: Text(
                  "로그아웃 하기",
                  style: AppTextStyles.bodyMediumBold.copyWith(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: OwnerBottomNavigation(currentIndex: 2),
    );
  }
}

// 2. 다이얼로그 구현 함수 (같은 클래스 내부에 작성)
void _showAccountDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 내용만큼만 높이 차지
          children: [
            const Text(
              "계좌 등록",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 은행명/계좌번호 입력 필드 예시
            TextField(
              decoration: InputDecoration(
                labelText: "은행명",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: "계좌번호",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "이름",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(), // 닫기
                    child: const Text("취소"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 등록 로직 실행
                      Get.back();
                      Get.snackbar("성공", "계좌가 등록되었습니다.");
                    },
                    child: const Text("등록"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}