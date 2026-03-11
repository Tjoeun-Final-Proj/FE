import 'package:boxmon/login/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      Dio(BaseOptions(baseUrl: 'http://boxmon.p-e.kr:8080/api/')),
      permanent: true,
    );
    Get.lazyPut<TokenService>(() => TokenService());
  }
}
