import 'package:boxmon/common/controller/shipment_controller.dart';
import 'package:boxmon/common/services/shipment_service.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/login/services/auth_service.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:boxmon/map/controllers/map_controller.dart';
import 'package:boxmon/map/model/map_view_model.dart';
import 'package:boxmon/map/services/map_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {

    /* 
    Get.put(
      Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/')),
      permanent: true,
    ); 
    */
    final naverDio = Dio(BaseOptions(
      baseUrl: 'https://maps.apigw.ntruss.com',
      headers: {
        'X-NCP-APIGW-API-KEY-ID': dotenv.env['X-NCP-APIGW-API-KEY-ID'],
        'X-NCP-APIGW-API-KEY': dotenv.env['X-NCP-APIGW-API-KEY'],
        'Accept': 'application/json',
      },
    ));
  // 1. 서비스 주입 (Dio를 사용하여 실제 API 통신 담당)
    Get.lazyPut<MapService>(() => MapService(dio: naverDio));

    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<ShipmentService>(() => ShipmentService());
    // 6. 컨트롤러들: 화면의 상태를 관리하고 비즈니스 로직을 실행
    Get.lazyPut<AuthController>(() => AuthController()); // 유저 인증 상태 관리

    final repository = NaverGeocodingRepository(Get.find<Dio>(), Get.find<MapService>());
    Get.lazyPut<MapViewModel>(() => MapViewModel(Get.find<MapService>(), repository));

    Get.lazyPut<ShipmentController>(() => ShipmentController());

  }
}