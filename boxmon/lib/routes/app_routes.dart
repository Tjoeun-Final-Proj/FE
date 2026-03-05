import 'package:boxmon/alarm/views/common_alarm.dart';
import 'package:boxmon/chatting/views/chat_room_view.dart';
import 'package:boxmon/chatting/views/common_chatting.dart';
import 'package:boxmon/common/views/cargo_detail_view.dart';
import 'package:boxmon/common/views/common_home.dart';
import 'package:boxmon/common/views/common_order.dart';
import 'package:boxmon/common/views/common_setting.dart';
import 'package:boxmon/common/views/common_start_package.dart';
import 'package:boxmon/common/views/dispatch_summary_view.dart';
import 'package:boxmon/common/views/ship_detail_screen.dart';
import 'package:boxmon/drive-list/views/common_inventory_view.dart';
import 'package:boxmon/drive-list/views/driver_invetory_view.dart';
import 'package:boxmon/login/bindings/auth_binding.dart';
import 'package:boxmon/login/views/common_login_view.dart';
import 'package:boxmon/login/views/common_registration_view.dart';
import 'package:boxmon/login/views/owner_login_view.dart';
import 'package:boxmon/login/views/owner_registration_view.dart';
import 'package:boxmon/login/views/select_login_view.dart';
import 'package:boxmon/login/views/splash_view.dart';
import 'package:boxmon/map/binding/map_binding.dart';
import 'package:boxmon/middlewares/driver_middleware.dart';
import 'package:boxmon/owner/views/owner_home.dart';
import 'package:boxmon/owner/views/owner_order.dart';
import 'package:boxmon/owner/views/owner_setting.dart';
import 'package:boxmon/payment/binding/payment_binding.dart';
import 'package:boxmon/payment/screens/result.dart';
import 'package:boxmon/payment/screens/tosspayments/payhome.dart';
import 'package:boxmon/payment/screens/tosspayments/payment.dart';
import 'package:boxmon/wallet/views/common_wallet_view.dart';
import 'package:boxmon/wallet/views/owner_wallet_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const splash = '/';
  static const selectLogin = '/select/login';
  static const login = '/user/login';
  static const register = '/user/register';
  static const ownerLogin = '/owner/login';
  static const ownerRegister = '/owner/register';
  static const ownerHome = '/owner/home';
  static const ownerOrder = '/owner/order';
  static const ownerSetting = '/owner/setting';
  static const commonHome = '/common/home';
  static const commonOrder = '/common/order';
  static const commonSetting = '/common/setting';
  static const commonStartPackage = '/common/start/package';
  static const tossPayments = '/toss/payments';
  static const tossPaymentsResult = '/toss/payments/result';
  static const resultPage = '/result';
  static const commonAlarm = '/common/alarm';
  static const commonChatting = '/common/chatting';
  static const chatRoom = '/chat/room';
  static const dispatchSummary = '/dispatch/summary';
  static const cargoDetail = '/cargo/detail';
  static const shipmentDetail = '/shipment-detail/:shipmentId'; // 자세히 보기
  static const commonWallet = '/common/wallet';
  static const ownerWallet = '/owner/wallet';
  static const shipperInventory = '/shipper/inventory';
  static const driverInventory = '/driver/inventory';

  static final routes = <GetPage>[
    GetPage(name: splash, page: () => SplashView()),

    GetPage(name: selectLogin, page: () => SelectLoginView()),

    GetPage(name: login, page: () => LoginView(), binding: AuthBinding()),

    GetPage(
      name: commonWallet,
      page: () => CommonWalletView(),
      binding: AuthBinding(),
    ),

    GetPage(name: ownerWallet,
      page: () => OwnerWalletView(),
      binding: AuthBinding(),
    ),
    
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
      middlewares: [
        // 여기에 미들웨어 추가! 
        // 이 수문장이 "DRIVER"인지 "SHIPPER"인지 체크해서 리다이렉트 시킵니다.
        DriverMiddleware(), 
      ],
    ),
    GetPage(
      name: ownerOrder,
      page: () => OwnerOrderView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
      middlewares: [
        // 여기에 미들웨어 추가! 
        // 이 수문장이 "DRIVER"인지 "SHIPPER"인지 체크해서 리다이렉트 시킵니다.
        DriverMiddleware(), 
      ],
    ),
    GetPage(
      name: ownerSetting,
      page: () => OwnerSettingView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
      middlewares: [
        // 여기에 미들웨어 추가! 
        // 이 수문장이 "DRIVER"인지 "SHIPPER"인지 체크해서 리다이렉트 시킵니다.
        DriverMiddleware(), 
      ],
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
      name: commonAlarm,
      page: () => CommonAlarm(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: commonChatting,
      page: () => CommonChatting(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: chatRoom,
      page: () => ChatRoomView(),
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

    GetPage(
      name: commonStartPackage,
      page: () => CommonStartPackageView(),
      binding: MapBinding(),
    ),

    GetPage(
      name: shipmentDetail,
      page: () => ShipDetailScreen(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: shipperInventory,
      page: () => CommonInvetoryView(),
      binding : AuthBinding(),
      transition: Transition.noTransition
    ),

    GetPage(
      name: driverInventory,
      page: () => DriverInvetoryView(),
      binding : AuthBinding(),
      transition: Transition.noTransition
    ),

    GetPage(name: cargoDetail, page: () => CargoDetailView(), binding: MapBinding()),
    GetPage(name: tossPayments, page: () => PayHome(), binding: PaymentBinding()),
    GetPage(name: tossPaymentsResult, page: () => Payment()),
    GetPage(name: resultPage, page: () => ResultPage()),
    GetPage(name: dispatchSummary, page: () => DispatchSummaryView(),
      binding: MapBinding(),
    ),
    // 로그인 이후
    // GetPage(
    //   name: home,
    //   page: () => HomeView(),
    //   binding: HomeBinding(),
    // ),
  ];
}
