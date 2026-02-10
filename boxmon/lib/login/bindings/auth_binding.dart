import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/login/services/auth_service.dart';
import 'package:boxmon/login/services/token_service.dart';
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
    // 6. 컨트롤러들: 화면의 상태를 관리하고 비즈니스 로직을 실행
    Get.lazyPut<AuthController>(() => AuthController()); // 유저 인증 상태 관리
  }
}