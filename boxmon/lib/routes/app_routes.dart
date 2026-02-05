import 'package:boxmon/login/bindings/auth_binding.dart';
import 'package:boxmon/login/views/common_login_view.dart';
import 'package:boxmon/login/views/common_registration_view.dart';
import 'package:boxmon/login/views/owner_login_view.dart';
import 'package:boxmon/login/views/owner_registration_view.dart';
import 'package:boxmon/login/views/splash_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const ownerLogin = '/owner/login';
  static const ownerRegister = '/owner/register';
  static const home = '/home';

  static final routes = <GetPage>[
    GetPage(
      name: splash,
      page: () => SplashView(),
    ),

    GetPage(
      name: login,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: register,
      page: () => RegistrationView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: ownerLogin,
      page: () => OwnerLoginView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: ownerRegister,
      page: () => OwnerRegistrationView(),
      binding: AuthBinding(),
    ),

    // 로그인 이후
    // GetPage(
    //   name: home,
    //   page: () => HomeView(),
    //   binding: HomeBinding(),
    // ),
  ];
}
