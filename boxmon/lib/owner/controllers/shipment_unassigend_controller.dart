import 'package:boxmon/owner/model/shipment_unassigned_response_model.dart';
import 'package:boxmon/owner/services/order_shipment_services.dart';
import 'package:get/get.dart';

class ShipmentUnassigedController extends GetxController {
  final OrderShipmentServices _shipmentService =
      OrderShipmentServices(); // 작성하신 서비스

  // 1. 상태 관리 변수들
  var unassignedShipments = <ShipmentUnassignedResponseModel>[].obs; // 미배차 리스트
  var isLoading = false.obs; // 로딩 상태

  @override
  void onInit() {
    super.onInit();
    // 컨트롤러가 생성될 때 데이터를 바로 불러옵니다.
    fetchUnassignedShipments();
  }

  // 2. 데이터 불러오기 함수
  Future<void> fetchUnassignedShipments() async {
    try {
      isLoading.value = true;

      // 서비스 호출
      final result = await _shipmentService.UnassignedShipments();

      if (result != null) {
        unassignedShipments.assignAll(result); // RxList에 데이터 할당
        print("✅ 컨트롤러: ${unassignedShipments.length}개의 미배차 내역 로드 완료");
      } else {
        print("⚠️ 컨트롤러: 데이터를 가져오지 못했습니다.");
      }
    } catch (e) {
      print("🚨 컨트롤러 에러: $e");
      Get.snackbar("오류", "데이터를 불러오는 중 문제가 발생했습니다.");
    } finally {
      isLoading.value = false;
    }
  }

  // 3. 당겨서 새로고침(Pull to Refresh)용 함수
  Future<void> refreshList() async {
    await fetchUnassignedShipments();
  }
}
