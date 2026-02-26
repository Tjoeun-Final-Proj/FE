import 'package:boxmon/common/controller/shipment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShipDetailScreen extends StatelessWidget {
  const ShipDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shipmentController = Get.find<ShipmentController>();

    // 화면 진입 시 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments['shipmentId'] != null) {
        shipmentController.loadDetail(Get.arguments['shipmentId']);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("상세정보", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (shipmentController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = shipmentController.detail.value;
        if (data == null) return const Center(child: Text("데이터 로드 실패"));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 헤더 (회사명 및 등록시간/날짜)
              Text(data.companyName ?? "상호미표기", 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("화물번호 : ${data.shipmentNumber}", 
                      style: const TextStyle(color: Colors.grey)),
                  // 🔥 날짜와 시간을 함께 표시 (예: 02/26 11:38)
                  Text("[${data.createdAt != null ? DateFormat('MM/dd HH:mm').format(data.createdAt!) : ''}]", 
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const Divider(height: 30, thickness: 1),

              // 2. 위치 정보 (상차지 - 경유지 - 하차지)
              _buildLocationInfo("상차지", data.pickupAddress ?? ""),
              
              if (data.waypoint1Address != null && data.waypoint1Address!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildLocationInfo("경유지1", data.waypoint1Address!),
              ],
              
              if (data.waypoint2Address != null && data.waypoint2Address!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildLocationInfo("경유지2", data.waypoint2Address!),
              ],

              const SizedBox(height: 10),
              _buildLocationInfo("하차지", data.dropoffAddress ?? ""),
              
              const SizedBox(height: 20),

              // 3. 표 형태의 상세 정보 카드
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildDataRow("화물종류", data.cargoType ?? "일반화물", "차종", data.vehicleType ?? "미지정"),
                    _buildDataRow("톤수", "${data.cargoWeight?.toInt()}톤", "운행방법", "편도"),
                    _buildDataRow("수수료", "${data.platformFee}원", "합계금액", "${data.profit}원", valueColor: Colors.blue[800]),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 4. 하단 버튼
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () { /* 배차신청 로직 */ },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("수정하기", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("돌아가기", style: TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              // 5. 주의사항
              const Text("• 적재중량은 화주와 통화하여 정확히 확인하시기 바랍니다.", 
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Text("• 상/하차기간 거리는 최단거리이므로 실제 도로거리와 다를 수 있습니다.", 
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
      }),
    );
  }

  // 상/하차지 표시용 위젯
  Widget _buildLocationInfo(String label, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 65,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // 표 형태의 데이터 로우 (2열 구성)
  Widget _buildDataRow(String label1, String value1, String label2, String value2, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildDataItem(label1, value1),
          _buildDataItem(label2, value2, color: valueColor),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value, {Color? color}) {
    if (label.isEmpty) return const Expanded(child: SizedBox());
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}