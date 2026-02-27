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

  Future<String?> createShipment(ShipmentModel request, {
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
          return shipmentId.toString().padLeft(6,'0');
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


  /// =================================================
  /// 화주, 차주 전용 배차 취소 함수
  /// - 반환 값 void 204
  /// =================================================
  /// final url ('shipment/:shipmentId/cancel')
  /// 바디 값없음
  /// Params => shipmentId << 반환된 값 받아와야됨
  Future<bool> cancelOrder(int shipmentId) async {
    try {
      final currentToken = _tokenService.accessToken;
      
      // 1. URL의 :shipmentId 부분을 실제 ID 값으로 치환해야 합니다.
      final url = 'shipment/$shipmentId/cancel';
      
      print("🌐 [API 요청] POST: $url");

      final response = await _dio.post(
        url,
        // 바디 값이 없으므로 data는 생략하거나 null을 전달합니다.
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      // 2. 204 No Content 혹은 200번대 상태 코드 확인
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        print("✅ [취소 성공] 상태 코드: ${response.statusCode}");
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
      print("❌ [Dio 에러] 메시지: ${e.response?.data}");
      return false;
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
      return false;
    }
  }

  /// =================================================
  /// 화주, 차주 전용 배차 취소에 취소하는 함수
  /// - 반환 값 void 204
  /// =================================================
  /// final url ('shipment/:shipmentId/cancel/drawable')
  /// 바디 값없음
  /// Params => shipmentId << 반환된 값 받아와야됨
  Future<bool> requestWithdrawCancel(int shipmentId) async {
    try {
      final currentToken = _tokenService.accessToken;
      
      // 1. URL의 :shipmentId 부분을 실제 ID 값으로 치환해야 합니다.
      final url = 'shipment/$shipmentId/cancel';
      
      print("🌐 [API 요청] POST: $url");

      final response = await _dio.post(
        url,
        // 바디 값이 없으므로 data는 생략하거나 null을 전달합니다.
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      // 2. 204 No Content 혹은 200번대 상태 코드 확인
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        print("✅ [취소 성공] 상태 코드: ${response.statusCode}");
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
      print("❌ [Dio 에러] 메시지: ${e.response?.data}");
      return false;
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
      return false;
    }
  }

  
  /// =================================================
  /// 화주가 배차 수락 받는 함수
  /// - 반환 값 void 204
  /// =================================================
  /// final url ('shipment/:shipmentId/accept')
  /// 바디 값없음
  /// Params => shipmentId << 반환된 값 받아와야됨
  Future<bool> acceptShipment(int shipmentId) async {
    try {
      final currentToken = _tokenService.accessToken;
      
      // 1. URL의 :shipmentId 부분을 실제 ID 값으로 치환해야 합니다.
      final url = 'shipment/$shipmentId/accept';
      
      print("🌐 [API 요청] POST: $url");

      final response = await _dio.post(
        url,
        // 바디 값이 없으므로 data는 생략하거나 null을 전달합니다.
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      // 2. 204 No Content 혹은 200번대 상태 코드 확인
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        print("✅ [취소 성공] 상태 코드: ${response.statusCode}");
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
      print("❌ [Dio 에러] 메시지: ${e.response?.data}");
      return false;
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
      return false;
    }
  }


  /// =================================================
  /// 차주가 운송 시작하는 함수
  /// - 반환 값 void 204
  /// =================================================
  /// final url ('shipment/:shipmentId/start')
  /// 바디 값없음
  /// Params => shipmentId << 반환된 값 받아와야됨
  Future<bool> startShipment(int shipmentId) async {
    try {
      final currentToken = _tokenService.accessToken;
      
      // 1. URL의 :shipmentId 부분을 실제 ID 값으로 치환해야 합니다.
      final url = 'shipment/$shipmentId/start';
      
      print("🌐 [API 요청] POST: $url");

      final response = await _dio.post(
        url,
        // 바디 값이 없으므로 data는 생략하거나 null을 전달합니다.
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      // 2. 204 No Content 혹은 200번대 상태 코드 확인
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        print("✅ [취소 성공] 상태 코드: ${response.statusCode}");
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
      print("❌ [Dio 에러] 메시지: ${e.response?.data}");
      return false;
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
      return false;
    }
  }

  
  /// =================================================
  /// 차주가 운송 완료했다고 하는 함수
  /// - 반환 값 void 204
  /// =================================================
  /// final url ('shipment/:shipmentId/complete')
  /// 바디 값없음
  /// Params => shipmentId << 반환된 값 받아와야됨
  /// 차주 운송 완료 처리 (사진 첨부 포함)
  Future<bool> finalShipment(int shipmentId, String imagePath) async {
    try {
      final currentToken = _tokenService.accessToken;
      final url = 'shipment/$shipmentId/complete';

      // 1. Multipart 파일 생성
      // 파일 경로에서 파일명을 추출하여 MultipartFile로 변환합니다.
      dio.MultipartFile file = await dio.MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );

      // 2. FormData 구성 (Key: dropoffPhoto)
      dio.FormData formData = dio.FormData.fromMap({
        "dropoffPhoto": file,
      });

      print("🌐 [API 요청] POST (Multipart): $url");

      final response = await _dio.post(
        url,
        data: formData, // JSON 대신 FormData를 전달
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $currentToken',
            // Multipart 요청임을 명시 (Dio가 자동으로 처리해주지만 명시하면 안전함)
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        print("✅ [운송 완료 성공] 상태 코드: ${response.statusCode}");
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
      print("❌ [Dio 에러] 메시지: ${e.response?.data}");
      return false;
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
      return false;
    }
  }
}
