import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<AuthController>(() => AuthController());
  //  Get.lazyPut<TokenService>(() => TokenService());
  }
}