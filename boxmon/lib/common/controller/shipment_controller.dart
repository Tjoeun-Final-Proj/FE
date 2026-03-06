import 'package:boxmon/chatting/controllers/chat_room_list_controller.dart';
import 'dart:io';

import 'package:boxmon/common/model/detail_shipment_model.dart';
import 'package:boxmon/common/model/shipment_model.dart';
import 'package:boxmon/common/model/shipment_response_model.dart';
import 'package:boxmon/common/services/shipment_service.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ShipmentController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();

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
  Future<void> submitShipment(ShipmentModel request, {File? files}) async {
    try {
      // 로딩 시작
      isLoading.value = true;
      print("🎮 [Controller] 배송 생성 프로세스 시작...");

      // 3. 서비스 호출 (ShipmentID를 받아옴)
      String? shipmentId = await _shipmentService.createShipment(request, files: files);

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

  /// 1. 배차 취소 실행 (POST /shipment/{id}/cancel)
  Future<void> requestCancel(int shipmentId) async {
    try {
      isLoading.value = true;
      bool success = await _shipmentService.cancelOrder(shipmentId);

      if (success) {
        Get.snackbar("성공", "배차가 성공적으로 취소되었습니다.",
            backgroundColor: Colors.blue, colorText: Colors.white);
        // 상태 갱신을 위해 상세 정보를 다시 불러오거나 홈으로 이동
        await loadDetail(shipmentId);
      } else {
        Get.snackbar("알림", "취소 처리에 실패했습니다.");
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. 취소 철회 실행 (POST /shipment/{id}/cancel/withdraw)
  Future<void> requestWithdrawCancel(int shipmentId) async {
    try {
      isLoading.value = true;
      // 아까 확인한 withdraw 엔드포인트 호출
      bool success = await _shipmentService.requestWithdrawCancel(shipmentId);

      if (success) {
        Get.snackbar("성공", "취소 철회가 완료되어 배차가 유지됩니다.",
            backgroundColor: Colors.green, colorText: Colors.white);
        await loadDetail(shipmentId); // UI 갱신
      } else {
        Get.snackbar("오류", "철회 요청을 처리할 수 없습니다.");
      }
    } finally {
      isLoading.value = false;
    }
  }

 /// 배차 수락 실행 (POST /shipment/{id}/accept)
Future<void> acceptShipment(int shipmentId) async {
  try {
    isLoading.value = true;
    bool success = await _shipmentService.acceptShipment(shipmentId);
    
    if (success) {
      Get.snackbar("성공", "배차를 수락했습니다.", 
          backgroundColor: Colors.blue, colorText: Colors.white);
      try {
        Get.find<ChatRoomListController>().onShipmentAccepted(shipmentId);
      } catch (_) {}
      // 수락 후 상태 갱신을 위해 상세 정보를 다시 불러옵니다.
      await loadDetail(shipmentId);
    } else {
      Get.snackbar("알림", "배차 수락에 실패했습니다.");
    }
  }

  /// 운송 시작하기 실행 (POST /shipment/{id}/start)
  Future<void> requestStartShipment(int shipmentId) async {
    try {
      isLoading.value = true;
      bool success = await _shipmentService.startShipment(shipmentId);

      if (success) {
        Get.snackbar("성공", "운송을 시작합니다.", backgroundColor: Colors.blue, colorText: Colors.white);
        // 🔥 중요: 상태가 IN_TRANSIT으로 바뀐 데이터를 다시 불러와야 버튼이 "운송 완료하기"로 바뀝니다!
        await loadDetail(shipmentId);
      } else {
        Get.snackbar("오류", "운송 시작 처리에 실패했습니다.");
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 운송 완료 프로세스 (사진 촬영 -> 업로드)
  Future<void> completeShipmentProcess(int shipmentId) async {
    try {
      // 1. 카메라로 사진 촬영
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50, // 용량 최적화
      );

      // 사용자가 촬영을 취소한 경우
      if (photo == null) return;

      // 2. 서버 전송 시작 시점에 로딩 시작
      isLoading.value = true;
      print("📸 촬영 완료: ${photo.path}");

      // 3. 서버에 업로드
      bool success = await _shipmentService.finalShipment(shipmentId, photo.path);

      if (success) {
        Get.snackbar("성공", "운송 완료 처리가 되었습니다.",
            backgroundColor: Colors.green, colorText: Colors.white);

        // 홈 화면으로 이동 (스택을 비우고 홈으로 가는 것을 추천)
        Get.offAllNamed('/owner/home');
      } else {
        Get.snackbar("오류", "서버 전송에 실패했습니다.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("🚨 운송 완료 처리 중 에러: $e");
      Get.snackbar("오류", "작업 수행 중 문제가 발생했습니다.");
    } finally {
      isLoading.value = false;
    }
  }
}
