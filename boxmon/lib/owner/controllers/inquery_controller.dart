import 'package:boxmon/owner/services/order_shipment_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 패키지 필요

class InqueryController extends GetxController {
  
  final OrderShipmentServices _inqueryService = Get.find<OrderShipmentServices>();

  // 1. 입력 필드 및 상태 변수
  final contentController = TextEditingController();
  final titleController = TextEditingController();
  var selectedCategory = "이용문의".obs;
  var isLoading = false.obs;

  // 2. 이미지 경로 변수 (이미지 한 장 기준)
  var imagePath = <String>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }

 // 사진 추가 함수
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // 리스트에 추가 (add)
      imagePath.add(pickedFile.path); 
    }
  }

  // 사진 삭제 함수
  void removeImage(int index) {
    // 특정 번호의 사진 삭제
    imagePath.removeAt(index); 
  }

  // 5. 서버 전송 함수 (등록하기 버튼 클릭 시)
  Future<void> submit() async {
    if (contentController.text.isEmpty) {
      Get.snackbar("알림", "문의 내용을 입력해주세요.");
      return;
    }

    try {
      isLoading.value = true;

      // 🎯 서비스 호출 시 리스트(imagePath)를 그대로 전달
      bool isSuccess = await _inqueryService.registerInquiry(
        contentController.text, 
        imagePath, // RxList는 그 자체로 List<String>처럼 동작함
      );

      if (isSuccess) {
        Get.back();
        Get.snackbar("성공", "문의가 등록되었습니다.");
      } else {
        Get.snackbar("실패", "등록 중 오류가 발생했습니다.");
      }
    } finally {
      isLoading.value = false;
    }
  }
}