import 'package:boxmon/login/bindings/auth_binding.dart';
import 'package:boxmon/login/controllers/auth_controller.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // .env 파일을 업로드
  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env 파일 로드 성공");
  } catch (e) {
    print("❌ .env 파일을 찾을 수 없습니다: $e");
  }
  await _initializeNaverMap();

  runApp(const MyApp());

  Get.put(AuthController(), permanent: true);
  Get.put(TokenService(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      initialBinding: AuthBinding(),
      theme: ThemeData(
        fontFamily: 'Pretendard', // Pretendard 폰트를 기본 폰트로 설정
      )
    );
  }
}

Future<void> _initializeNaverMap() async {
  String clientId = dotenv.env['NAVER_MAP_CLIENT_ID'] ?? '';
  if (clientId.isEmpty) {
    print("❌ [NaverMap] .env에서 Client ID를 찾을 수 없습니다! .env 파일과 pubspec.yaml 설정을 확인하세요.");
    return;
  }
  try {
    await FlutterNaverMap().init(
      clientId: clientId, // 네이버 클라우드 플랫폼에서 발급받은 클라이언트 아이디로 교체
      onAuthFailed: (ex) {
        print("네이버 지도 인증 실패: $ex");
        if (ex is NQuotaExceededException) {
          print("사용량 초과 (message: ${ex.message})");
        }
      },
    );
    print("네이버 지도 초기화 성공");
  } catch (e) {
    print("네이버 지도 초기화 실패: $e");
  } 
}