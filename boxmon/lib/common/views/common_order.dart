import 'package:boxmon/common/controller/shipment_controller.dart';
import 'package:boxmon/common/model/shipment_response_model.dart';
import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/common_bottom_navigation.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonOrderView extends StatelessWidget {
  CommonOrderView({super.key});

  final AuthController authController = Get.find<AuthController>();

  // 1. ShipmentController 찾아오기
  final ShipmentController shipmentController = Get.put(ShipmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(),
      // 2. RefreshIndicator를 넣어 당겨서 새로고침 가능하게 함
      body: RefreshIndicator(
        onRefresh: () => shipmentController.fetchMyUnassigned(),
        child: Obx(() {
          // 3. 로딩 상태 처리
          if (shipmentController.isLoading.value &&
              shipmentController.unassignedList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // 4. 데이터가 없을 때 처리
          if (shipmentController.unassignedList.isEmpty) {
            return const Center(child: Text("현재 등록된 미배차 오더가 없습니다."));
          }

          // 5. 실제 리스트 렌더링
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shipmentController.unassignedList.length,
            itemBuilder: (context, index) {
              final item = shipmentController.unassignedList[index];
              return _buildOrderItem(item);
            },
          );
        }),
      ),
      // 속성 이름을 bottomNavigationBar로 수정하세요!
      bottomNavigationBar: CommonBottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildOrderItem(ShipmentResponseModel item) {
    // 날짜 포맷팅 함수 (예: 02/26 09:37)
    String formatDateTime(DateTime? dt) {
      if (dt == null) return "미정";
      return "${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')} "
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    }

    return GestureDetector(
      // 🎯 1. 카드 전체를 클릭 가능하게 만듦
      onTap: () {
        print("탭 클릭됨! ID: ${item.shipmentId}"); // 디버깅용 로그

        // 🎯 2. 상세 페이지로 이동하며 ID 전달
        Get.toNamed(
          AppRoutes.shipmentDetail,
          arguments: {
            'shipmentId': item.shipmentId, // 상세 페이지 컨트롤러가 이 값을 받음
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 출발지 >> 도착지
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.pickupAddress ?? "출발지 미정",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.double_arrow_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.dropoffAddress ?? "도착지 미정",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 2. 배지 + 거리 + 상차 날짜/시간
            Row(
              children: [
                Text(
                  "${item.estimatedDistance?.toStringAsFixed(1) ?? '0.0'}KM",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // 🔥 날짜와 시간이 함께 표시됨 (상차 희망일시)
                Text(
                  formatDateTime(item.pickupDesiredAt),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
            const SizedBox(height: 14),

            // 3. 화물 정보 (무게 / 차량 / 비고 정렬)
            Row(
              children: [
                // 무게와 차량 종류 강조
                Text(
                  "${item.cargoWeight?.toInt() ?? 0}톤 / ${item.vehicleType ?? '차종미정'}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                // 🔥 비고(Description)를 오른쪽 끝으로 배치
                Expanded(
                  child: Text(
                    item.description != null && item.description!.isNotEmpty
                        ? item.description!
                        : "", // 비어있으면 표시 안함
                    textAlign: TextAlign.right, // 오른쪽 정렬
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 4. 하단부 (결제 방식 및 금액)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [const SizedBox(width: 6)]),
                Text(
                  "${item.profit?.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원",
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
