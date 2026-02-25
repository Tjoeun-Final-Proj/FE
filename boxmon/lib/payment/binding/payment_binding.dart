import 'package:boxmon/login/services/token_service.dart';
import 'package:boxmon/payment/services/payment_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080/api/')),
      permanent: true,
    );
    
    Get.lazyPut<PaymentService>(() => PaymentService());
    Get.lazyPut<TokenService>(() => TokenService());
  }
}