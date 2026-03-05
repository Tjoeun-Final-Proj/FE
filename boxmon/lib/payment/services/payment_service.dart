import 'dart:convert';

import 'package:boxmon/login/models/token_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class PaymentService extends GetxService {
  String? accessToken;
  String? refreshToken;
  late Token token;
  final dio.Dio _dio =
      Get.find<dio.Dio>(); // Base URL이 http://10.0.2.2:8080/api 로 설정된채로 가져와짐
  final TokenService _tokenService = Get.find<TokenService>();

  Future<dynamic> createPayment(
    String paymentKey,
    String orderId,
    num amount,
  ) async {
    try {
      final currentToken = _tokenService.accessToken;

      print("🚀 [Payment API] 결제 최종 승인 요청 시작");

      // 1. 전송 데이터 구성
      final jsonData = {
        'paymentKey': paymentKey,
        'shipmentId': orderId,
        'amount': amount,
      };

      // 💡 실제 서버로 날아가는 JSON 문자열을 그대로 찍어보세요.
      // 여기서 타입 오류(따옴표 유무 등)를 바로 잡을 수 있습니다.
      print("📤 [REQUEST BODY JSON]: ${jsonEncode(jsonData)}");

      final requestHeaders = {
        'Authorization': 'Bearer $currentToken',
        'Content-Type': 'application/json',
      };

      // 2. 서버에 POST 요청 (엔드포인트: payment/confirm)
      final response = await _dio.post(
        'payment/confirm',
        data: jsonData,
        options: dio.Options(headers: requestHeaders),
      );

      print("✅ [RESPONSE STATUS]: ${response.statusCode}");
      print("📥 [RESPONSE BODY]: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 성공 시 로직
        return response.data;
      }
    } on dio.DioException catch (e) {
      print("❌ [Payment API Error] ❌");
      if (e.response != null) {
        print("🚩 상태 코드: ${e.response?.statusCode}");
        // 💡 400 에러 시 서버가 보낸 구체적인 필드 에러 메시지를 확인하세요.
        print("📦 서버 응답 내용: ${e.response?.data}");
      } else {
        print("📝 메시지: ${e.message}");
      }
    } catch (e) {
      print("🚨 [CRITICAL ERROR]: $e");
    }
    return null;
  }
}
