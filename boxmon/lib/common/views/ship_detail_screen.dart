import 'package:boxmon/common/controller/shipment_controller.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class ShipDetailScreen extends StatelessWidget {
  const ShipDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shipmentController = Get.find<ShipmentController>();
    // 새로 추가되는 부분: 사용자 역할 확인
    final tokenService = Get.find<TokenService>();
    final isShipper = tokenService.userType == "SHIPPER";

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
        title: const Text(
          "상세정보",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
              Text(
                data.companyName ?? "상호미표기",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "화물번호 : ${data.shipmentNumber}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  // 🔥 날짜와 시간을 함께 표시 (예: 02/26 11:38)
                  Text(
                    "[${data.createdAt != null ? DateFormat('MM/dd HH:mm').format(data.createdAt!) : ''}]",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 1),

              // 2. 위치 정보 (상차지 - 경유지 - 하차지)
              _buildLocationInfo("상차지", data.pickupAddress ?? ""),

              if (data.waypoint1Address != null &&
                  data.waypoint1Address!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildLocationInfo("경유지1", data.waypoint1Address!),
              ],

              if (data.waypoint2Address != null &&
                  data.waypoint2Address!.isNotEmpty) ...[
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
                    _buildDataRow(
                      "화물종류",
                      data.cargoType ?? "일반화물",
                      "차종",
                      data.vehicleType ?? "미지정",
                    ),
                    _buildDataRow(
                      "톤수",
                      "${data.cargoWeight?.toInt()}톤",
                      "운행방법",
                      "편도",
                    ),
                    _buildDataRow(
                      "수수료",
                      "${data.platformFee}원",
                      "합계금액",
                      "${isShipper ? data.price : data.profit}원", // 역할에 따라 다른 필드 표시
                      valueColor: Colors.blue[800],
                    ),
                  ],
                ),
              ),
              if (data.shipmentStatus == "DONE")
                _buildPhotoSection(
                  data.cargoPhotoUrl ??
                      "https://picsum.photos/seed/cargo/400/300", // 여기 바꿔야되요 지금 네이버 모름
                  data.dropoffPhotoUrl ??
                      "https://picsum.photos/seed/drop/400/300",
                ),

              const SizedBox(height: 30),

              Obx(() => _buildBottomButtons(shipmentController)),

              const SizedBox(height: 30),
              // 5. 주의사항
              const Text(
                "• 적재중량은 화주와 통화하여 정확히 확인하시기 바랍니다.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Text(
                "• 상/하차기간 거리는 최단거리이므로 실제 도로거리와 다를 수 있습니다.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
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
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
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
  Widget _buildDataRow(
    String label1,
    String value1,
    String label2,
    String value2, {
    Color? valueColor,
  }) {
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

  Widget _buildBottomButtons(ShipmentController controller) {
    final data = controller.detail.value;
    if (data == null) return const SizedBox.shrink();

    final tokenService = Get.find<TokenService>();
    final isShipper = tokenService.userType == "SHIPPER";
    final status = data.shipmentStatus; // 서버에서 내려오는 상태값

    // 1. 화주(SHIPPER)인 경우
    if (isShipper) {
      switch (status) {
        case "CANCELED":
          return _buildSingleButton(
            text: "운송 취소됨 (돌아가기)",
            color: const Color.fromARGB(255, 255, 107, 107),
            onPressed: () => Get.back(), // 완료 상태에선 그냥 뒤로가기
          );

        case "ASSIGNED":
          return _buildSingleButton(
            text: "배차 취소",
            color: Colors.red[400]!,
            onPressed: () => _showConfirmDialog(
              "취소 승인이 필요합니다",
              "이미 차주가 배정된 상태입니다. 화주님의 취소 요청을 차주가 확인하고 동의해야 최종 취소가 완료됩니다.",
              () => controller.requestWithdrawCancel(data.shipmentId!),
              cancelText: "돌아가기",
              confirmText: "취소 요청하기",
            ),
          );
        case "DONE":
          return _buildSingleButton(
            text: "운송 완료됨 (돌아가기)",
            color: Colors.grey[600]!,
            onPressed: () => Get.back(), // 완료 상태에선 그냥 뒤로가기
          );

        case "IN_TRANSIT": // 현재 운송 중
          return _buildSingleButton(
            text: "기사님이 안전하게 배송중이에요",
            color: Colors.green[700]!,
            onPressed: () {},
          );

        case "REQUESTED":
          return Column(
            children: [
              _buildSingleButton(
                text: "기사님 매칭 중",
                color: const Color.fromARGB(255, 94, 91, 177),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 10),
              _buildSingleButton(
                text: "배차 요청 취소",
                color: Colors.red[400]!,
                onPressed: () => _showConfirmDialog(
                  "배차 요청을 취소하시겠습니까?",
                  "차주가 배정되기 전에는 언제든 취소가 가능하며,\n취소 시 정보를 다시 입력해야 할 수 있습니다.",
                  () => controller.requestCancel(data.shipmentId!),
                ),
              ),
            ],
          );
      }
    }

    // 2. 차주(DRIVER)인 경우 - 상태별(status) 분기 처리
    switch (status) {
      // 🔥 배차 수락이 필요한 상태들 (서버마다 이름이 다를 수 있음)
      // 🏁 운송이 완전히 끝난 상태
      case "DONE":
        return _buildSingleButton(
          text: "운송 완료됨 (돌아가기)",
          color: Colors.grey[600]!,
          onPressed: () => Get.back(), // 완료 상태에선 그냥 뒤로가기
        );

      case "CANCELED":
        return _buildSingleButton(
          text: "운송 취소됨 (돌아가기)",
          color: const Color.fromARGB(255, 255, 107, 107),
          onPressed: () => Get.back(), // 완료 상태에선 그냥 뒤로가기
        );

      // ✅ 내가 이미 수락해서 배정된 상태
      case "ASSIGNED":
        return Column(
          children: [
            _buildSingleButton(
              text: "운송 시작하기",
              color: Colors.blue[700]!,
              onPressed: () => _showConfirmDialog(
                "운송 시작",
                "운송을 시작하시겠습니까?",
                () => controller.requestStartShipment(data.shipmentId!),
              ),
            ),
            const SizedBox(height: 10),
            _buildSingleButton(
              text: "배차 포기(취소)",
              color: Colors.red[300]!,
              onPressed: () => _showConfirmDialog(
                "배차 취소 요청 전 확인",
                "화주와 합의되지 않은 일방적인 취소는 분쟁의 원인이 될 수 있습니다. 화주측 수락이 있어야 최종 취소됩니다.",
                () => controller.requestWithdrawCancel(data.shipmentId!),
                cancelText: "돌아가기",
                confirmText: "화주에게 취소 요청",
              ),
            ),
          ],
        );

      case "IN_TRANSIT": // 현재 운송 중
        return _buildSingleButton(
          text: "운송 완료하기 (사진촬영)",
          color: Colors.green[700]!,
          onPressed: () => controller.completeShipmentProcess(data.shipmentId!),
        );

      // 그 외 예상치 못한 상태일 때 기본으로 수락 버튼을 보여줌
      default:
        return _buildSingleButton(
          text: "배차 수락",
          color: const Color(0xFF333333),
          onPressed: () => controller.acceptShipment(data.shipmentId!),
        );
    }
  }

  // 공통 버튼 위젯 (코드 중복 방지)
  Widget _buildSingleButton({
    required String text,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          disabledBackgroundColor: Colors.grey[300], // 비활성화 색상
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 다이얼로그 헬퍼
  void _showConfirmDialog(
    String title,
    String content,
    VoidCallback onConfirm, {
    String cancelText = "유지하기",
    String confirmText = "취소하기",
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA69996),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        cancelText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055AB),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. 사진 섹션 위젯 정의
  Widget _buildPhotoSection(String? cargoUrl, String? dropoffUrl) {
    // 둘 다 없으면 섹션 자체를 숨김
    if (cargoUrl == null && dropoffUrl == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 40, thickness: 1),
        const Text(
          "운송 증빙 사진",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            // 상차 사진
            if (cargoUrl != null)
              Expanded(child: _buildPhotoItem("상차 사진", cargoUrl)),
            if (cargoUrl != null && dropoffUrl != null)
              const SizedBox(width: 12),
            // 하차 사진
            if (dropoffUrl != null)
              Expanded(child: _buildPhotoItem("하차 사진", dropoffUrl)),
          ],
        ),
      ],
    );
  }

  // 2. 개별 사진 아이템 (클릭 시 확대 기능을 넣으면 더 좋습니다)
  Widget _buildPhotoItem(String label, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            // 로딩 중 표시
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 150,
                color: Colors.grey[100],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            // 에러 시 대체 이미지
            errorBuilder: (context, error, stackTrace) => Container(
              height: 150,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataItem(String label, String value, {Color? color}) {
    if (label.isEmpty) return const Expanded(child: SizedBox());
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
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
