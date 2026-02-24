import 'package:boxmon/common/model/shipment_model.dart';
import 'package:boxmon/login/models/token_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class ShipmentService extends GetxService {
  
  String? accessToken;
  String? refreshToken;
  late Token token;
  final dio.Dio _dio =
      Get.find<dio.Dio>(); // Base URL이 http://10.0.2.2:8080/api 로 설정된채로 가져와짐
  final TokenService _tokenService = Get.find<TokenService>();

  // 배송 생성하는 로직
  Future<void> createShipment(ShipmentModel request) async {
    try {
      final response = await _dio.post('api/shipment', 
      data: request.toJson());
      // 응답 데이터 처리
      print("📥 서버 응답 바디: ${response.data}");
    } on dio.DioException catch (e) {
      print("❌ Dio 에러: ${e.response?.data}");
    } catch (e) {
      print("❌ 일반 에러: $e");
    }
  }
}
