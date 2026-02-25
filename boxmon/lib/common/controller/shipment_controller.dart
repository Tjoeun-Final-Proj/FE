import 'package:boxmon/common/model/shipment_model.dart';
import 'package:boxmon/common/services/shipment_service.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:get/get.dart';

class ShipmentController extends GetxController {
  // 1. 서비스 찾아오기
  final ShipmentService _shipmentService = Get.find<ShipmentService>();

  // 2. UI 상태 관리용 변수
  var isLoading = false.obs;

  /// 배송 요청 실행 함수
  Future<void> submitShipment(ShipmentModel request) async {
    try {
      // 로딩 시작
      isLoading.value = true;
      print("🎮 [Controller] 배송 생성 프로세스 시작...");

      // 3. 서비스 호출 (ShipmentID를 받아옴)
      int? shipmentId = await _shipmentService.createShipment(request);

      // 4. 결과값(ID)에 따른 분기 처리
      if (shipmentId != null) {
  // 1. 먼저 이동하고
  Get.toNamed(AppRoutes.tossPayments, arguments: {
    'shipmentId': shipmentId,
    'amount': request.price,
  });

  // 2. 이동한 화면 위에서 스낵바 표시
  Future.delayed(const Duration(milliseconds: 500), () {
    Get.snackbar("성공", "배송 요청이 정상적으로 등록되었습니다.");
  });
} else {
        print("❌ [Controller] 배송 생성 실패 (ID가 null임)");
        Get.snackbar(
          "오류", 
          "배송 생성에 실패했습니다. 다시 시도해주세요.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("🚨 [Controller] 예상치 못한 에러: $e");
    } finally {
      // 성공하든 실패하든 로딩 해제
      isLoading.value = false;
    }
  }
}