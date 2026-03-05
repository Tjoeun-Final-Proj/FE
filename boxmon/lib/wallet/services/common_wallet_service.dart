import 'package:boxmon/login/models/token_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:boxmon/wallet/model/common_wallet_month_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class CommonWalletService extends GetxService {
  String? accessToken;
  String? refreshToken;
  late Token token;
  final dio.Dio _dio =
      Get.find<dio.Dio>(); // Base URL이 http://10.0.2.2:8080/api 로 설정된채로 가져와짐
  final TokenService _tokenService = Get.find<TokenService>();

  Future<Map<String, dynamic>?> getSettlementSummary() async {
    try {
      final currentToken = _tokenService.accessToken;

      print("🌐 [Wallet API] 정산 요약 정보 요청 시작");
      print("🚀 [Payment API] 결제 최종 승인 요청 시작");

      final response = await _dio.get(
        'shipments/settlements/shipper/summary',
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      print("✅ [응답 성공]: ${response.data}");

      if (response.statusCode == 200) {
        return response.data; // 그냥 Map 자체를 리턴
      }
    } catch (e) {
      print("🚨 에러 발생: $e");
    }
    return null;
  }

  Future<List<CommonWalletMonthModel>?> getSettlementList(
    int year,
    int month,
  ) async {
    try {
      final currentToken = _tokenService.accessToken;

      print("🌐 [Wallet API] 월별 정산 리스트 요청: $year년 $month월");

      final response = await _dio.get(
        'shipments/settlements/shipper', // 엔드포인트
        queryParameters: {'year': year, 'month': month},
        options: dio.Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      // 성공 시 호출된 최종 URL 출력
      print("✅ [Wallet API List Success] 상태 코드: ${response.statusCode}");
      print("🔗 [Wallet API] 정상 호출된 URL: ${response.realUri}");

      if (response.statusCode == 200 && response.data != null) {
        // JSON 리스트를 모델 리스트로 변환하여 반환
        return CommonWalletMonthModel.fromJsonList(response.data);
      }
    } on dio.DioException catch (e) {
      print(
        "❌ [Wallet API List Error] ${e.response?.statusCode}: ${e.response?.data}",
      );
    } catch (e) {
      print("🚨 [Critical Error] $e");
    }
    return null;
  }
}
