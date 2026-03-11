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
        print("🚩 상태 메시지: ${e.response?.statusMessage}");
        print(
          "🌐 요청 URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}",
        );
        print("📌 요청 메서드: ${e.requestOptions.method}");
        print("📌 요청 헤더: ${e.requestOptions.headers}");
        print("📌 응답 헤더: ${e.response?.headers.map}");

        final dynamic responseData = e.response?.data;
        if (responseData is Map || responseData is List) {
          print(
            "📦 서버 응답 내용(JSON): ${const JsonEncoder.withIndent('  ').convert(responseData)}",
          );
        } else {
          print("📦 서버 응답 내용(Raw): $responseData");
        }
      } else {
        print("📝 메시지: ${e.message}");
      }
      print("📌 DioExceptionType: ${e.type}");
    } catch (e) {
      print("🚨 [CRITICAL ERROR]: $e");
    }
    return null;
  }
}
