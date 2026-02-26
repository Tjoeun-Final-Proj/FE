import 'package:boxmon/common/model/detail_shipment_model.dart';
import 'package:boxmon/common/model/shipment_model.dart';
import 'package:boxmon/common/model/shipment_response_model.dart';
import 'package:boxmon/common/services/shipment_service.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:get/get.dart';

class ShipmentController extends GetxController {
  // 1. 서비스 찾아오기
  final ShipmentService _shipmentService = Get.find<ShipmentService>();

  // 2. UI 상태 관리용 변수
  var isLoading = false.obs;

  // 목록 조회를 위한 Rx 리스트 추가
  var unassignedList = <ShipmentResponseModel>[].obs;
  var detail = Rxn<ShipDetailResponseModel>();
@override
void onInit() {
  super.onInit();
  print("🚀 [ShipmentController] onInit 호출됨");

  // 페이지 이동 시 arguments에 담긴 ID가 있는지 확인
  if (Get.arguments != null && Get.arguments['shipmentId'] != null) {
    int id = Get.arguments['shipmentId'];
    print("🎯 상세 정보 로딩 시작 (ID: $id)");
    loadDetail(id); // 상세 데이터 로드 함수 호출
  } else {
    // 인자가 없으면 목록 조회 (리스트 화면인 경우)
    print("📋 목록 화면 모드 - 전체 데이터 로드");
    fetchMyUnassigned();
  }
}
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

Future<void> loadDetail(int id) async {
    isLoading.value = true;
    final result = await _shipmentService.getShipmentDetail(id);
    if (result != null) {
      detail.value = result;
    }
    isLoading.value = false;
  }
  Future<void> fetchMyUnassigned() async {
  try {
    isLoading.value = true;
    print("🔄 [Controller] 목록 동기화 시작...");
    
    var result = await _shipmentService.getMyUnassignedShipments();
    
    if (result != null) {
      unassignedList.assignAll(result);
      print("🎯 [Controller] 변환 성공! 아이템 개수: ${unassignedList.length}개");
      
      // 첫 번째 아이템 데이터 샘플 로그
      if (unassignedList.isNotEmpty) {
        print("📝 [샘플 데이터] 첫 번째 ID: ${unassignedList[0].shipmentId}, 출발지: ${unassignedList[0].pickupAddress}");
      }
    } else {
      print("⚠️ [Controller] 서비스로부터 null을 반환받음");
    }
  } finally {
    isLoading.value = false;
    print("🏁 [Controller] 로딩 상태 종료 (isLoading: ${isLoading.value})");
  }
}
}