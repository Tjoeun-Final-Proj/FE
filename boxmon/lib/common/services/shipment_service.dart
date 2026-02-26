import 'dart:convert';
import 'dart:io';

import 'package:boxmon/common/model/detail_shipment_model.dart';
import 'package:boxmon/common/model/shipment_model.dart';
import 'package:boxmon/common/model/shipment_response_model.dart';
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

  Future<int?> createShipment(ShipmentModel request, {
    File? files, // 단일 파일 전송
  }) async {
    try {
      final currentToken = _tokenService.accessToken; 
  
  print("🔑 [DEBUG] 통신 직전 토큰: $currentToken"); // 여기서 최신 로그와 대조!
      
      // 1. 토큰 자체 값 확인 로그
      print("🔑 [DEBUG] _tokenService.accessToken: ${_tokenService.accessToken ?? 'NULL'}");

      print("🚀 [Shipment API] 배송 생성 요청 시작");
      
      final formData = dio.FormData();
      // JSON 파트 추가 (Spring @RequestPart와 대응)
      formData.files.add(
  MapEntry(
    'request',
    dio.MultipartFile.fromString(
      jsonEncode(request.toJson()), // 실제 데이터가 담긴 객체를 변환해서 보내야 함!
      contentType: dio.DioMediaType('application', 'json'),
    ),
  ),
);

      // 이미지 파트 추가
      if (files != null) {
        formData.files.add(
          MapEntry(
            'cargoPhoto', // 서버 API 명세에 따라 'file' 또는 'files' 확인 필수!
            await dio.MultipartFile.fromFile(
              files.path,
              filename: files.path.split('/').last,
              contentType: dio.DioMediaType('image', 'jpeg'),
            ),
          ),
        );
      }
      // 2. 요청 직전 헤더 구성을 미리 정의
      final requestHeaders = {
        'Authorization': 'Bearer $currentToken',
      };

      // 3. 실제로 보낼 헤더 상세 로그
      print("📝 [HEADER LOG] 전송 예정 헤더: $requestHeaders");
      print("📤 [REQUEST BODY]: $formData");

      // 4. 서버에 POST 요청
      final response = await _dio.post(
        'shipment', 
        data: formData,
        options: dio.Options(
          contentType : 'multipart/form-data',
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

Future<List<ShipmentResponseModel>?> getMyUnassignedShipments() async {
  try {
    final currentToken = _tokenService.accessToken;
    
    print("🌐 [API 요청] GET: /shipment/my/unassigned");
    print("🔑 [AUTH TOKEN] Bearer ${currentToken?.substring(0, 10)}..."); // 보안상 앞부분만

    final response = await _dio.get(
      'shipment/my/unassigned',
      options: dio.Options(
        headers: {'Authorization': 'Bearer $currentToken'},
      ),
    );

    print("✅ [응답 성공] 상태 코드: ${response.statusCode}");
    print("📦 [응답 데이터] Raw JSON: ${response.data}"); // 데이터 구조 확인용

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ShipmentResponseModel.fromJson(json)).toList();
    }
  } on dio.DioException catch (e) {
    print("❌ [Dio 에러] 경로: ${e.requestOptions.path}");
    print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
    print("❌ [Dio 에러] 서버 메시지: ${e.response?.data}");
    print("❌ [Dio 에러] 요청 헤더: ${e.requestOptions.headers}");
  } catch (e) {
    print("🚨 [알 수 없는 에러]: $e");
  }
  return null;
}


// 디테일로 보는 shipment
// 상세 조회를 위한 서비스 함수
Future<ShipDetailResponseModel?> getShipmentDetail(int shipmentId) async {
  try {
    final currentToken = _tokenService.accessToken;
    
    // 1. URL 파라미터 적용 (문자열 보간법 사용)
    final String url = 'shipment/accept-detail/$shipmentId';
    
    print("🌐 [API 요청] GET: $url");
    print("🔑 [AUTH TOKEN] Bearer ${currentToken?.substring(0, 10)}...");

    final response = await _dio.get(
      url,
      options: dio.Options(
        headers: {'Authorization': 'Bearer $currentToken'},
      ),
    );

    print("✅ [응답 성공] 상태 코드: ${response.statusCode}");
    // 상세 조회는 보통 리스트가 아닌 Map(객체) 하나가 옵니다.
    print("📦 [응답 데이터] Raw JSON: ${response.data}"); 

    if (response.statusCode == 200 && response.data != null) {
      // 2. 단일 객체로 파싱하여 반환
      return ShipDetailResponseModel.fromJson(response.data);
    }
  } on dio.DioException catch (e) {
    print("❌ [Dio 에러] 경로: ${e.requestOptions.path}");
    print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
    print("❌ [Dio 에러] 서버 메시지: ${e.response?.data}");
  } catch (e) {
    print("🚨 [알 수 없는 에러]: $e");
  }
  return null;
}


}
