import 'package:boxmon/common/controller/shipment_controller.dart';
import 'package:boxmon/common/services/shipment_service.dart';
import 'package:boxmon/drive-list/services/inventory_service.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/login/services/auth_service.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:boxmon/owner/controllers/inquery_controller.dart';
import 'package:boxmon/owner/controllers/vehicle_register_controller.dart';
import 'package:boxmon/owner/services/order_shipment_services.dart';
import 'package:boxmon/wallet/services/common_wallet_service.dart';
import 'package:boxmon/wallet/services/owner_wallet_servcie.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/')),
      permanent: true,
    );

    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<ShipmentService>(() => ShipmentService());
    Get.lazyPut<CommonWalletService>(() => CommonWalletService());
    // 6. 컨트롤러들: 화면의 상태를 관리하고 비즈니스 로직을 실행
    Get.lazyPut<AuthController>(() => AuthController()); // 유저 인증 상태 관리
    Get.lazyPut<ShipmentController>(() => ShipmentController());
    Get.lazyPut<OwnerWalletServcie>(() => OwnerWalletServcie());
    Get.lazyPut<InventoryService>(() => InventoryService());
    Get.lazyPut<OrderShipmentServices>(() => OrderShipmentServices());
    Get.lazyPut<VehicleRegisterController>(() => VehicleRegisterController());
    Get.lazyPut<InqueryController>(() => InqueryController());
  }
}
