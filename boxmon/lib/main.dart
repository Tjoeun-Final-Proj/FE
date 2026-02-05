import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false, // 앱 실행 시 디버그 리본 제거
//       initialRoute: AppRoutes.SPLASH, // 앱이 켜졌을 때 스플래쉬 화면을 가장 먼저 보여줌
//       getPages: AppRoutes.routes, // 앱에서 사용할 모든 화면(Route)의 지도를 등록
//       initialBinding:
//           AuthBinding(), // 앱이 시작될 때 가장 먼저 메모리에 올려둘 컨트롤러를 AuthBinding으로 설정
//     );
//   }
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}