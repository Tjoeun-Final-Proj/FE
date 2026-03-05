import 'package:boxmon/common/model/detail_shipment_model.dart';
import 'package:boxmon/login/models/token_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:boxmon/owner/model/shipment_unassigned_response_model.dart';
import 'package:boxmon/owner/model/vehicle_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class OrderShipmentServices extends GetxService {
  String? accessToken;
  String? refreshToken;
  late Token token;
  final dio.Dio _dio =
      Get.find<dio.Dio>(); // Base URL이 http://10.0.2.2:8080/api 로 설정된채로 가져와짐
  final TokenService _tokenService = Get.find<TokenService>();

  Future<List<ShipmentUnassignedResponseModel>?> UnassignedShipments() async {
    try {
      final currentToken = _tokenService.accessToken;

      print("🌐 [API 요청] GET: /shipment/unassigned");
      print(
        "🔑 [AUTH TOKEN] Bearer ${currentToken?.substring(0, 10)}...",
      ); // 보안상 앞부분만

      final response = await _dio.get(
        'shipment/unassigned',
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      print("✅ [응답 성공] 상태 코드: ${response.statusCode}");
      print("📦 [응답 데이터] Raw JSON: ${response.data}"); // 데이터 구조 확인용

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => ShipmentUnassignedResponseModel.fromJson(json))
            .toList();
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

  // 관리자 차량 등록하는 함수입니다.
  // 차량 등록 실행 함수
  Future<bool> registerVehicle(VehicleModel vehicle) async {
    try {
      final currentToken = _tokenService.accessToken;

      print("🌐 [Vehicle Service] 차량 등록 요청 시작");

      final response = await _dio.post(
        'driver/vehicle',
        // 🎯 여기서 모델의 toJson()을 호출합니다.
        // 컨트롤러에서 굳이 Map으로 변환해서 줄 필요가 없어집니다.
        data: vehicle.toJson(),
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ [Vehicle Service] 차량 등록 성공");
        return true;
      }
    } on dio.DioException catch (e) {
      print(
        "❌ [Vehicle Service Error] ${e.response?.statusCode}: ${e.response?.data}",
      );
    } catch (e) {
      print("🚨 [Vehicle Service Critical] $e");
    }
    return false;
  }

  // 차주 계좌 등록하는 함수입니다.

  Future<bool> registerAccount(
    String bankCode,
    String accountNumber,
    String holderName,
  ) async {
    try {
      final currentToken = _tokenService.accessToken;

      print("🌐 [user/account Service] 차량 등록 요청 시작");

      final response = await _dio.post(
        'user/account',
        // 🎯 여기서 모델의 toJson()을 호출합니다.
        // 컨트롤러에서 굳이 Map으로 변환해서 줄 필요가 없어집니다.
        data: {
          'bankCode': bankCode, // 변수명을 Key로 바로 매핑
          'accountNumber': accountNumber,
          'holderName': holderName,
        },
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ [account Service] 차량 등록 성공");
        return true;
      }
    } on dio.DioException catch (e) {
      print(
        "❌ [account Service Error] ${e.response?.statusCode}: ${e.response?.data}",
      );
    } catch (e) {
      print("🚨 [account Service Critical] $e");
    }
    return false;
  }

  // 차주/화주 공통 문의 등록하는 함수입니다.

  Future<bool> registerInquiry(String content, List<String> imagePaths) async {
    try {
      final currentToken = _tokenService.accessToken;

      // 1. 파일들을 MultipartFile 리스트로 변환
      List<dio.MultipartFile> multipartFileList = [];
      for (String path in imagePaths) {
        multipartFileList.add(
          await dio.MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          ),
        );
      }

      // 2. FormData 구성 (Key: dropoffPhoto)
      dio.FormData formData = dio.FormData.fromMap({
        "contactContent": content,
        "images": multipartFileList,
      });

      // 3. API 호출
      final response = await _dio.post(
        'contact/create', // 실제 문의 등록 엔드포인트로 변경하세요
        data: formData, // FormData 전달
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $currentToken',
            // Multipart 전송 시 Content-Type은 Dio가 자동으로 지정해주므로 생략 가능합니다.
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ [Inquiry Service] 문의 등록 성공");
        return true;
      }
    } on dio.DioException catch (e) {
      print(
        "❌ [Inquiry Service Error] ${e.response?.statusCode}: ${e.response?.data}",
      );
    } catch (e) {
      print("🚨 [Inquiry Service Critical] $e");
    }
    return false;
  }
}
