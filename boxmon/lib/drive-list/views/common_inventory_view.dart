import 'package:boxmon/drive-list/controller/inventory_controller.dart';
import 'package:boxmon/drive-list/model/inventory_model.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommonInvetoryView extends StatelessWidget {
  CommonInvetoryView({super.key});

  final AuthController authController = Get.find<AuthController>();

  // 1. ShipmentController 찾아오기
  final InventoryController shipmentController = Get.put(InventoryController());
  
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
        onRefresh: () => shipmentController.onRefresh(),
        child: Obx(() {
          // 3. 로딩 상태 처리
          if (shipmentController.isLoading.value && shipmentController.inventoryList.isEmpty) {
    return Center(child: CircularProgressIndicator());
  }
  return ListView.builder(
    itemCount: shipmentController.inventoryList.length,
    itemBuilder: (context, index) => _buildOrderItem(shipmentController.inventoryList[index]),
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
          // 2. 위치 정보 (출발지 - 경유지 - 도착지)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // 상단 정렬
            children: [
              // 왼쪽 커스텀 인디케이터 (점-선-점)
              Column(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.blue.shade400),
                  // 경유지 개수에 따라 선의 길이를 조절하거나 추가합니다.
                  Container(
                    width: 1, 
                    height: (item.waypoint1Address?.isNotEmpty == true && item.waypoint2Address?.isNotEmpty == true) 
                      ? 80 : (item.waypoint1Address?.isNotEmpty == true) ? 45 : 20, 
                    color: Colors.grey.shade300
                  ),
                  Icon(Icons.location_on, size: 14, color: Colors.red.shade400),
                ],
              ),
              const SizedBox(width: 12),
              
              // 오른쪽 주소 텍스트 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 출발지 ---
                    Text(
                      item.pickupAddress ?? "출발지 미정",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),

                    // --- 🔥 경유지 1 (있을 때만 표시) ---
                    if (item.waypoint1Address != null && item.waypoint1Address!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text("경유1", style: TextStyle(color: Colors.orange.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.waypoint1Address!,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // --- 🔥 경유지 2 (있을 때만 표시) ---
                    if (item.waypoint2Address != null && item.waypoint2Address!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text("경유2", style: TextStyle(color: Colors.orange.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.waypoint2Address!,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 8),
                    // --- 도착지 ---
                    Text(
                      item.dropoffAddress ?? "도착지 미정",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                  Text(
                    "${formatPrice(item.price)}원",
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