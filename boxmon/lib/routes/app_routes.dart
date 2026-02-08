import 'package:boxmon/login/bindings/auth_binding.dart';
import 'package:boxmon/login/views/common_login_view.dart';
import 'package:boxmon/login/views/common_registration_view.dart';
import 'package:boxmon/login/views/owner_login_view.dart';
import 'package:boxmon/login/views/owner_registration_view.dart';
import 'package:boxmon/login/views/splash_view.dart';
import 'package:boxmon/common/views/common_home.dart';
import 'package:boxmon/common/views/common_order.dart';
import 'package:boxmon/common/views/common_setting.dart';
import 'package:boxmon/owner/views/owner_home.dart';
import 'package:boxmon/owner/views/owner_order.dart';
import 'package:boxmon/owner/views/owner_setting.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const ownerLogin = '/owner/login';
  static const ownerRegister = '/owner/register';
  static const ownerHome = '/owner/home';
  static const ownerOrder = '/owner/order';
  static const ownerSetting = '/owner/setting';
  static const commonHome = '/common/home';
  static const commonOrder = '/common/order';
  static const commonSetting = '/common/setting';

  static final routes = <GetPage>[
    GetPage(name: splash, page: () => SplashView()),

    GetPage(name: login, page: () => LoginView(), binding: AuthBinding()),

    GetPage(
      name: register,
      page: () => RegistrationView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: ownerHome,
      page: () => OwnerHomeView(),
      binding: AuthBinding(),
      transition: Transition.noTransition, // 이 페이지만 줌 효과 제거
    ),
    GetPage(
      name: ownerOrder,
      page: () => OwnerOrderView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: ownerSetting,
      page: () => OwnerSettingView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: commonHome,
      page: () => CommonHomeView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: commonOrder,
      page: () => CommonOrderView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: commonSetting,
      page: () => CommonSettingView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
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
