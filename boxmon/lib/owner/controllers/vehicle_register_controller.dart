import 'package:boxmon/owner/model/vehicle_model.dart';
import 'package:boxmon/owner/services/order_shipment_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleRegisterController extends GetxController {
  // 텍스트 필드 제어
  final OrderShipmentServices _inventoryService = Get.find<OrderShipmentServices>();

  final vehicleNumberController = TextEditingController();
  final weightController = TextEditingController();

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

  @override
  void onClose() {
    vehicleNumberController.dispose();
    weightController.dispose();
    super.onClose();
  }
}