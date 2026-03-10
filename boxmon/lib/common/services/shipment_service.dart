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
  
  // Base URL이 http://10.0.2.2:8080/api 로 설정된채로 가져와짐
  final dio.Dio _dio = Get.find<dio.Dio>();
  final TokenService _tokenService = Get.find<TokenService>();

  /// 배송 생성 (사진 포함)
  Future<String?> createShipment(ShipmentModel request, {File? files}) async {
    try {
      final currentToken = _tokenService.accessToken;
      final formData = dio.FormData();

      // 1. 보내는 JSON 데이터 조립 및 로그 출력
      final Map<String, dynamic> requestMap = request.toJson();
      final String requestJson = const JsonEncoder.withIndent('  ').convert(requestMap);

      print("==============================================");
      print("📤 [REQUEST JSON] 서버로 보내는 데이터:");
      print(requestJson);
      print("🖼️ [FILE] 사진 첨부 여부: ${files != null ? 'YES (${files.path})' : 'NO'}");
      print("==============================================");

      // JSON 파트 추가
      formData.files.add(
        MapEntry(
          'request',
          dio.MultipartFile.fromString(
            jsonEncode(requestMap),
            contentType: dio.DioMediaType('application', 'json'),
          ),
        ),
      );

      // 이미지 파트 추가
      if (files != null) {
        formData.files.add(
          MapEntry(
            'cargoPhoto',
            await dio.MultipartFile.fromFile(
              files.path,
              filename: files.path.split('/').last,
              contentType: dio.DioMediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      // 2. 서버 요청 실행
      final response = await _dio.post(
        'shipment',
        data: formData,
        options: dio.Options(
          contentType: 'multipart/form-data',
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      // 3. 받는 응답 데이터 로그 출력
      print("==============================================");
      print("📥 [RESPONSE] 서버에서 받은 데이터:");
      print("상태 코드: ${response.statusCode}");
      print(const JsonEncoder.withIndent('  ').convert(response.data));
      print("==============================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic rawId = response.data['shipmentId'];
        if (rawId != null) {
          return rawId.toString().padLeft(6, '0');
        }
      }
    } on dio.DioException catch (e) {
      print("❌ [DioError] ${e.response?.statusCode} : ${e.response?.data}");
    } catch (e) {
      print("🚨 [Error] $e");
    }
    return null;
  }

  /// 미배정 배송 목록 조회
  Future<List<ShipmentResponseModel>?> getMyUnassignedShipments() async {
    try {
      final currentToken = _tokenService.accessToken;

      print("🌐 [API 요청] GET: /shipment/my/unassigned");
      print("🔑 [AUTH TOKEN] Bearer ${currentToken?.substring(0, 10)}...");

      final response = await _dio.get(
        'shipment/my/unassigned',
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      print("✅ [응답 성공] 상태 코드: ${response.statusCode}");
      print("📦 [응답 데이터] Raw JSON: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ShipmentResponseModel.fromJson(json)).toList();
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

  /// 배송 상세 정보 조회
  Future<ShipDetailResponseModel?> getShipmentDetail(int shipmentId) async {
    try {
      final currentToken = _tokenService.accessToken;
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
      print("📦 [응답 데이터] Raw JSON: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        return ShipDetailResponseModel.fromJson(response.data);
      }
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 경로: ${e.requestOptions.path}");
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
    }
    return null;
  }

  /// 배차 취소
  Future<bool> cancelOrder(int shipmentId) async {
    try {
      final currentToken = _tokenService.accessToken;
      final url = 'shipment/$shipmentId/cancel';

      print("🌐 [API 요청] POST: $url");

      final response = await _dio.post(
        url,
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        print("✅ [취소 성공] 상태 코드: ${response.statusCode}");
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
      return false;
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
      return false;
    }
  }

  /// 취소 철회
  Future<bool> requestWithdrawCancel(int shipmentId) async {
    try {
      final currentToken = _tokenService.accessToken;
      final url = 'shipment/$shipmentId/cancel/withdraw';

      print("🌐 [API 요청] POST: $url");

      final response = await _dio.post(
        url,
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        print("✅ [철회 성공] 상태 코드: ${response.statusCode}");
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
      return false;
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
      return false;
    }
  }

  /// 배차 수락
  Future<bool> acceptShipment(int shipmentId) async {
    try {
      final currentToken = _tokenService.accessToken;
      final url = 'shipment/$shipmentId/accept';

      print("🌐 [API 요청] POST: $url");

      final response = await _dio.post(
        url,
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        print("✅ [수락 성공] 상태 코드: ${response.statusCode}");
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
      return false;
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
      return false;
    }
  }

  /// 운송 시작
  Future<bool> startShipment(int shipmentId) async {
    try {
      final currentToken = _tokenService.accessToken;
      final url = 'shipment/$shipmentId/start';

      print("🌐 [API 요청] POST: $url");

      final response = await _dio.post(
        url,
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        print("✅ [운송 시작 성공] 상태 코드: ${response.statusCode}");
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ [Dio 에러] 상태 코드: ${e.response?.statusCode}");
      return false;
    } catch (e) {
      print("🚨 [알 수 없는 에러]: $e");
      return false;
    }
  }

  /// 운송 완료 (사진 첨부)
  Future<bool> finalShipment(int shipmentId, String imagePath) async {
    try {
      final currentToken = _tokenService.accessToken;
      final url = 'shipment/$shipmentId/complete';

      dio.MultipartFile file = await dio.MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );

      dio.FormData formData = dio.FormData.fromMap({
        "dropoffPhoto": file,
      });

      print("🌐 [API 요청] POST (Multipart): $url");

      final response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $currentToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
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