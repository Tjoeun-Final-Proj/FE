import 'package:boxmon/drive-list/model/inventory_model.dart';
import 'package:boxmon/login/models/token_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class InventoryService extends GetxService {
  
  String? accessToken;
  String? refreshToken;
  late Token token;
  final dio.Dio _dio =
      Get.find<dio.Dio>(); // Base URL이 http://10.0.2.2:8080/api 로 설정된채로 가져와짐
  final TokenService _tokenService = Get.find<TokenService>();

  Future<List<InventoryModel>?> shipmentinventory() async {
  try {
    final currentToken = _tokenService.accessToken;
    
    print("🌐 [Wallet API] 정산 요약 정보 요청 시작");
      print("🚀 [Payment API] 결제 최종 승인 요청 시작");
      
     final response = await _dio.get(
      'shipment/my/inventory/shipper',
      options: dio.Options(headers: {'Authorization': 'Bearer $currentToken'}),
    );

    print("✅ [응답 성공]: ${response.data}");

    if (response.statusCode == 200 && response.data != null) {
      // 🚨 핵심: 여기서 모델 리스트로 변환해서 리턴해야 합니다!
      return InventoryModel.fromJsonList(response.data as List<dynamic>);
    }
  } catch (e) {
    print("🚨 에러 발생: $e");
  }
  return null;
}

Future<List<InventoryModel>?> driverinventory() async {
  try {
    final currentToken = _tokenService.accessToken;
    
    final response = await _dio.get(
      'shipment/my/inventory/driver',
      options: dio.Options(headers: {'Authorization': 'Bearer $currentToken'}),
    );


    if (response.statusCode == 200 && response.data != null) {
      // 🚨 핵심: 여기서 모델 리스트로 변환해서 리턴해야 합니다!
      return InventoryModel.fromJsonList(response.data as List<dynamic>);
    }
  } catch (e) {
    print("🚨 [Critical Error] $e");
  }
  return null;
}
}