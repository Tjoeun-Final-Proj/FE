import 'package:boxmon/common/model/shipment_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';


class ShipmentController extends GetxController{
  // 1. 상태 관리 변수
  final _dio = dio.Dio(dio.BaseOptions(baseUrl: 'https://your-api-url.com/')); // BaseURL 설정
  
  var isLoading = false.obs; // 로딩 상태 (UI에서 스피너 돌릴 때 사용)

  // 2. 배송 생성 로직
  Future<void> createShipment(ShipmentModel request) async {
    try {
      isLoading.value = true; // 로딩 시작

      // 서버로 데이터 전송
      final response = await _dio.post(
        'api/shipment', 
        data: request.toJson(), // 아까 만든 toJson() 사용
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("📥 서버 응답: ${response.data}");
        
        // 성공 시 로직 (예: 이전 화면으로 이동, 성공 알림)
        Get.back(); 
        Get.snackbar('성공', '배송 요청이 정상적으로 생성되었습니다.');
      }
      
    } on dio.DioException catch (e) {
      // Dio 에러 처리
      String errorMessage = e.response?.data?['message'] ?? "알 수 없는 에러가 발생했습니다.";
      print("❌ Dio 에러: ${e.response?.data}");
      Get.snackbar('오류', errorMessage, snackPosition: SnackPosition.BOTTOM);
      
    } catch (e) {
      // 일반 에러 처리
      print("❌ 일반 에러: $e");
      Get.snackbar('오류', '데이터 처리 중 에러가 발생했습니다.');
      
    } finally {
      isLoading.value = false; // 성공하든 실패하든 로딩 종료
    }
  }
}