import 'package:boxmon/login/models/token_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:boxmon/map/model/location_log_request.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class LocationService {

  String? accessToken;
  String? refreshToken;
  late Token token;
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: 'http://10.0.2.2:8080/api/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );
  final TokenService _tokenService = Get.find<TokenService>();


  LocationService() {
    // 🎯 [핵심] HTTP 통신 과정을 포스트맨처럼 다 보여주는 로그 인터셉터 추가
    _dio.interceptors.add(dio.LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,    // 👈 전송하는 JSON 바디 확인
      responseHeader: false,
      responseBody: true,   // 👈 서버에서 온 결과 확인
      error: true,
      logPrint: (obj) => print("🌐 [HTTP] $obj"), // 태그 붙여서 가독성 업
    ));
  }

  // 위치 로그 전송 함수
  Future<bool> sendLocationLog(LocationLogRequest request) async {
    try {
      final currentToken = _tokenService.accessToken;
    
      final payload = request.toServerPayload();
      
      // 🎯 [상세 로그] 전송 직전의 데이터 상태를 명시적으로 출력
      print("--------------------------------------------------");
      print("🚀 [Location Service] 전송 시도 시작");
      print("🆔 Shipment ID: ${request.shipmentId}");
      print("📦 Chunk Data (String): ${payload['locationChunk']}"); 
      print("--------------------------------------------------");

      final response = await _dio.post(
        'location-log',
        data: payload,
        options: dio.Options(headers: {'Authorization': 'Bearer $currentToken'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ [Location Service] 서버 전송 성공 (상태코드: ${response.statusCode})");
        return true;
      }
    } on dio.DioException catch (e) {
      // 🎯 [에러 로그] 무엇 때문에 실패했는지 상세히 표시
      print("❌ [Location Service Error]");
      print("   - Code: ${e.response?.statusCode}");
      print("   - Data: ${e.response?.data}");
      print("   - Msg: ${e.message}");
      
      if (e.type == dio.DioExceptionType.connectionTimeout) {
        print("   ⚠️ 서버 연결 시간 초과 (10.0.2.2 주소 확인 필요)");
      }
    } catch (e) {
      print("🚨 [Location Service Critical] 예상치 못한 오류: $e");
    }
    return false;
  }
}