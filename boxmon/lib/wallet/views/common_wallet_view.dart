import 'package:boxmon/wallet/controller/common_wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommonWalletView extends StatelessWidget {
  const CommonWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommonWalletController());

    // 🔥 실제로 메모리에 올라간 컨트롤러의 진짜 이름을 출력해봅니다.
    print("🕵️ 현재 화면에 잡힌 컨트롤러 타입: ${controller.runtimeType}");

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "정산 관리",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshAll(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 요약 카드는 변화가 적으므로 따로 Obx 처리
                Obx(() => _buildSummaryCard(controller)),
                const SizedBox(height: 16),

                // 2. 월 선택 바 (날짜 텍스트만 바뀌면 되므로 해당 부분만 Obx)
                _buildMonthSelector(controller),
                const SizedBox(height: 16),

                // 3. 리스트 영역 (이 부분만 Obx로 감싸서 리스트 변화에만 반응하게 함)
                Obx(() {
                  if (controller.isLoading.value &&
                      controller.settlementList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.settlementList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text("내역이 없습니다."),
                      ),
                    );
                  }

                  return Column(
                    children: controller.settlementList.map((item) {
                      // 데이터 변환 로직...
                      return _buildWalletItem(
                        date: DateFormat('MM/dd').format(item.createdAt!),
                        status: item.shipmentStatus ?? "상태미정",
                        price:
                            "${NumberFormat('#,###').format(item.price ?? 0)}원",
                        pickup: item.pickupAddress ?? "",
                        time: DateFormat('HH:mm').format(item.createdAt!),
                        dropoffAddress: item.dropoffAddress ?? "",
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 위젯 함수들 ---

Widget _buildSummaryCard(CommonWalletController controller) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "이번달 정산 금액",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            Text(
              "${controller.thisMonthTotal}원",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              "저번달 보다",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            Text(
              "${controller.differenceAmount}원 ${controller.isSaved ? '절약했습니다.' : '더 지출했습니다.'}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: controller.isSaved ? Colors.blue : Colors.red,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildMonthSelector(CommonWalletController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => controller.changeMonth(-1), // 이전 달
        ),
        Obx(
          () => Text(
            "${controller.selectedYear.value}년 ${controller.selectedMonth.value}월",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
          onPressed: () => controller.changeMonth(1), // 다음 달
        ),
      ],
    ),
  );
}

Widget _buildWalletItem({
  required String date,
  required String status,
  required String price,
  required String pickup,
  required String time,
  required String dropoffAddress,
}) {
  // 상태별 색상 로직 (간단 예시)
  Color statusColor = status == "운송완료" ? Colors.blue[900]! : Colors.green;
  if (status == "미배차") statusColor = Colors.red;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 50,
          child: Column(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pickup,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "$time | $dropoffAddress",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
