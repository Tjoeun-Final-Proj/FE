import 'package:boxmon/drive-list/controller/inventory_controller_driver.dart';
import 'package:boxmon/drive-list/model/inventory_model.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DriverInvetoryView extends StatelessWidget {
  DriverInvetoryView({super.key});

  final AuthController authController = Get.find<AuthController>();

  // 1. ShipmentController 찾아오기
  final controller = Get.put(InventoryControllerWithDriver());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "운송 현황",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      // 2. RefreshIndicator를 넣어 당겨서 새로고침 가능하게 함
      body: RefreshIndicator(
        onRefresh: () => controller.onRefresh(),
        child: Obx(() {
          // 3. 로딩 상태 처리
          if (controller.isLoading.value && controller.inventoryList.isEmpty) {
    return Center(child: CircularProgressIndicator());
  }
  return ListView.builder(
    itemCount: controller.inventoryList.length,
    itemBuilder: (context, index) => _buildOrderItem(controller.inventoryList[index]),
  );
})
      ),
    );
  }
Widget _buildOrderItem(InventoryModel item) {
  // 날짜 포맷팅 (02.26 09:37)
  String formatDateTime(DateTime? dt) {
    if (dt == null) return "미정";
    return "${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} "
           "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  // 금액 포맷팅 (9,000)
  String formatPrice(int? price) => 
      NumberFormat('#,###').format(price ?? 0);

  return GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.shipmentDetail, arguments: {'shipmentId': item.shipmentId}),
    child: Container(
      margin: const EdgeInsets.only(bottom: 16), // ListView 패딩이 있으므로 아래쪽만 마진
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 상태 배지 & 날짜
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (item.shipmentStatus == "취소됨") ? Colors.red.shade50 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.shipmentStatus ?? "대기중",
                  style: TextStyle(
                    color: (item.shipmentStatus == "취소됨") ? Colors.red : Colors.blue.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "상차일: ${formatDateTime(item.pickupDesiredAt)}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. 출발지 & 도착지 (세로 정렬로 가독성 강화)
          Row(
            children: [
              Column(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.blue.shade400),
                  Container(width: 1, height: 20, color: Colors.grey.shade300),
                  Icon(Icons.location_on, size: 14, color: Colors.red.shade400),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.pickupAddress ?? "출발지 미정",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.dropoffAddress ?? "도착지 미정",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32, thickness: 0.8),

          // 3. 차량 정보 & 가격
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.cargoWeight?.toInt() ?? 0}톤 · ${item.vehicleType ?? '차종미정'}",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (item.description != null && item.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        item.description!,
                        style: TextStyle(fontSize: 11, color: Colors.orange.shade700),
                      ),
                    ),
                  Text(
                    "${formatPrice(item.profit)}원",
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}