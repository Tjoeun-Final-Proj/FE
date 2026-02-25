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

  Future<int?> createShipment(ShipmentModel request) async {
    try {
      final currentToken = _tokenService.accessToken; 
  
  print("🔑 [DEBUG] 통신 직전 토큰: $currentToken"); // 여기서 최신 로그와 대조!
      
      // 1. 토큰 자체 값 확인 로그
      print("🔑 [DEBUG] _tokenService.accessToken: ${_tokenService.accessToken ?? 'NULL'}");

      print("🚀 [Shipment API] 배송 생성 요청 시작");
      
      final jsonData = request.toJson();
      
      // 2. 요청 직전 헤더 구성을 미리 정의
      final requestHeaders = {
        'Authorization': 'Bearer $currentToken',
        'Content-Type': 'application/json', // 기본적으로 필요
      };

      // 3. 실제로 보낼 헤더 상세 로그
      print("📝 [HEADER LOG] 전송 예정 헤더: $requestHeaders");
      print("📤 [REQUEST BODY]: $jsonData");

      // 4. 서버에 POST 요청
      final response = await _dio.post(
        'shipment', 
        data: jsonData,
        options: dio.Options(
          headers: requestHeaders,
        ),
      );

      // ... 이하 성공 로직 동일 ...
      print("✅ [RESPONSE STATUS]: ${response.statusCode}");
      print("📥 [RESPONSE BODY]: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic rawId = response.data['shipmentId'];
        if (rawId != null) {
          final int shipmentId = rawId as int;
          print("🎯 [SUCCESS] 추출된 Shipment ID: $shipmentId");
          return shipmentId;
        }
      }
      
    } on dio.DioException catch (e) {
      print("❌ [DioException] 발생!");
      if (e.response != null) {
        print("  - 에러 상태 코드: ${e.response?.statusCode}");
        print("  - 에러 응답 데이터: ${e.response?.data}");
        // 🔥 실제 Dio 요청 객체에 담겼던 헤더를 다시 확인
        print("  - 실제 보낸 헤더: ${e.requestOptions.headers}");
        print("  - 요청 경로: ${e.requestOptions.path}");
      } else {
        print("  - 에러 메시지: ${e.message}");
      }
    } catch (e) {
      print("🚨 [CRITICAL ERROR]: $e");
    }
    
    return null;
  }
}
