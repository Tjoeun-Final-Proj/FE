import 'package:boxmon/owner/model/vehicle_model.dart';
import 'package:boxmon/owner/services/order_shipment_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleRegisterController extends GetxController {
  // 텍스트 필드 제어
  final OrderShipmentServices _inventoryService =
      Get.find<OrderShipmentServices>();

  final vehicleNumberController = TextEditingController();
  final weightController = TextEditingController();
  final bankCodeController = TextEditingController();
  final accountNumberController = TextEditingController();
  final holderNameController = TextEditingController();

  // 관찰 가능한 변수들 (유지)
  var vehicleType = "CARGO".obs;
  var isRefrigerated = false.obs;
  var isFrozen = false.obs;
  var isLoading = false.obs;

  // 등록 로직
  Future<void> submit() async {
    if (vehicleNumberController.text.isEmpty) {
      Get.snackbar("알림", "차량 번호를 입력해주세요.");
      return;
    }

    try {
      isLoading.value = true;

      // 모델 객체 생성
      final vehicle = VehicleModel(
        vehicleNumber: vehicleNumberController.text,
        vehicleType: vehicleType.value, // 컨트롤러의 obs 변수 사용
        canRefrigerate: isRefrigerated.value,
        canFreeze: isFrozen.value,
        weightCapacity: double.tryParse(weightController.text) ?? 1.0,
      );

      // 서비스 호출
      bool isSuccess = await _inventoryService.registerVehicle(vehicle);

      if (isSuccess) {
        Get.back();
        Get.snackbar("성공", "차량이 등록되었습니다.");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 계좌 등록 로직 (Controller 내부)
  Future<void> checkAccount() async {
    // 1. 유효성 검사 (빈 값 체크)
    if (accountNumberController.text.isEmpty) {
      Get.snackbar("알림", "계좌 번호를 입력해주세요.");
      return;
    }

    try {
      isLoading.value = true;

      // 2. 서비스 호출
      // 모델을 안 쓰기로 했으니, 각각의 문자열 값을 인자로 던집니다.
      bool isSuccess = await _inventoryService.registerAccount(
        bankCodeController.text, // 선택된 은행 코드
        accountNumberController.text, // 입력된 계좌 번호
        holderNameController.text, // 입력된 예금주명
      );

      // 3. 결과 처리
      if (isSuccess) {
        Get.back(); // 이전 화면으로 이동
        Get.snackbar("성공", "계좌가 성공적으로 등록되었습니다.");
      } else {
        Get.snackbar("실패", "등록에 실패했습니다. 다시 시도해주세요.");
      }
    } catch (e) {
      Get.snackbar("에러", "네트워크 오류가 발생했습니다.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    vehicleNumberController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
