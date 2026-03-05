import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/owner_bottom_navigation.dart';
import 'package:boxmon/core/design/app_design.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/owner/controllers/vehicle_register_controller.dart';
import 'package:boxmon/owner/views/my_inquery_view.dart';
import 'package:boxmon/owner/views/inquery_view.dart';
import 'package:boxmon/owner/views/vehicle_register_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerSettingView extends StatelessWidget {
  OwnerSettingView({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final vehicleController = Get.put(VehicleRegisterController());
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
                        "차량 관리",
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
  "차량 등록하기",
  style: TextStyle(color: Colors.grey[600], fontSize: 13),
),
const SizedBox(height: 12),
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey[200]!),
    borderRadius: BorderRadius.circular(12),
  ),
  child: ListTile(
    // 🎯 다이얼로그 대신 새 페이지로 이동!
    onTap: () => Get.to(() => const VehicleRegisterView()), 
    leading: const Icon(Icons.car_crash_rounded, color: Colors.black),
    title: const Text(
      "차량 등록",
      style: TextStyle(fontWeight: FontWeight.w500),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
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
            ...["공지사항", "문의하기", "내 문의 목록 보기","시스템 설정"].map((title) {
              IconData icon;
              if (title == "공지사항")
                icon = Icons.check_circle_outline;
              else if (title == "문의하기")
                icon = Icons.headset_mic_outlined;
                else if (title =="내 문의 목록 보기")
                icon = Icons.chat_bubble_outline_rounded; // 💬 말풍선 아이콘
              
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
  if (title == "문의하기") {
    Get.to(() => const InqueryView());
  } else if(title == "내 문의 목록 보기") {
    Get.to(() => const MyInqueryView());
    }{
    // 공지사항, 시스템 설정 등 아직 안 만든 메뉴들
    Get.snackbar(
      "알림", 
      "$title 기능은 현재 준비 중입니다.",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
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
void _showAccountDialog() {
  final controller = Get.find<VehicleRegisterController>();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 헤더 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "계좌 등록",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "운송비 정산을 위한 계좌 정보를 입력해주세요.",
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // 2. 입력 섹션
            _buildDialogInput(
              controller: controller.bankCodeController,
              label: "은행 선택",
              hint: "은행 이름을 입력하세요",
              icon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: 16),
            _buildDialogInput(
              controller: controller.accountNumberController,
              label: "계좌 번호",
              hint: "'-' 없이 숫자만 입력",
              icon: Icons.credit_card_outlined,
              isNumber: true,
            ),
            const SizedBox(height: 16),
            _buildDialogInput(
              controller: controller.holderNameController,
              label: "예금주 명",
              hint: "실명 입력",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 32),

            // 3. 버튼 영역
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value 
                ? null 
                : () => controller.checkAccount(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A2F4B), // 다크 블루 톤
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: controller.isLoading.value
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("등록 완료", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ),
    ),
  );
}

// 다이얼로그 전용 깔끔한 입력창 위젯
Widget _buildDialogInput({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  bool isNumber = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54)),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1A2F4B)),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A2F4B), width: 1.5),
          ),
        ),
      ),
    ],
  );
}