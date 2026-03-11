import 'package:boxmon/payment/controllers/payment_result_controller.dart';
import 'package:boxmon/routes/app_routes.dart'; //
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 컨트롤러 주입 (onInit에서 서버 승인 자동 실행)
    final controller = Get.put(PaymentResultController());

    // Get.arguments 데이터
    final Success res = Get.arguments as Success;
    final formatter = NumberFormat('#,###');
    final formattedAmount = formatter.format(res.amount);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '결제 완료',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      // 💡 Obx로 감싸서 컨트롤러의 상태를 지켜봅니다.
      body: Obx(() {
        // 2. 서버 승인(Confirm) 통신 중일 때는 로딩 화면을 보여줍니다.
        if (controller.isConfirming.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF0047AB)),
                SizedBox(height: 20),
                Text("결제 승인 처리 중입니다...", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // 3. 승인 실패 시 실패 화면
        if (!controller.isSuccess.value) {
          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.error_outline,
                  size: 90,
                  color: Color(0xFFD32F2F),
                ),
                const SizedBox(height: 24),
                const Text(
                  "결제 승인에 실패했습니다.",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "잠시 후 다시 시도해주세요.",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow("주문 번호", res.orderId),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(color: Color(0xFFE9ECEF), thickness: 1),
                        ),
                        _buildSummaryRow("결제 금액", "$formattedAmount원"),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => Get.offAllNamed(AppRoutes.commonOrder),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0047AB),
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          '주문 내역으로 이동',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Get.offAllNamed(AppRoutes.commonHome),
                        child: const Text(
                          '홈으로 돌아가기',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // 4. 승인 성공 화면
        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.check_circle,
                size: 90,
                color: Color(0xFF0047AB),
              ),
              const SizedBox(height: 24),
              const Text(
                "결제가 성공했습니다!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "배송 기사님이 곧 배정될 예정입니다.",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 40),

              // 요약 카드 (기존 UI 유지)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow("주문 번호", res.orderId),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: Color(0xFFE9ECEF), thickness: 1),
                      ),
                      _buildSummaryRow(
                        "결제 금액",
                        "$formattedAmount원",
                        isPrice: true,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // 하단 버튼 (기존 UI 유지)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Get.offAllNamed(AppRoutes.commonOrder),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0047AB),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        '주문 내역 확인하기',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Get.offAllNamed(AppRoutes.commonHome),
                      child: const Text(
                        '홈으로 돌아가기',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // 정보를 한 줄씩 보여주는 헬퍼 위젯
  Widget _buildSummaryRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF495057), fontSize: 15),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrice ? 18 : 15,
            fontWeight: isPrice ? FontWeight.bold : FontWeight.w500,
            color: isPrice ? const Color(0xFF0047AB) : Colors.black,
          ),
        ),
      ],
    );
  }
}

