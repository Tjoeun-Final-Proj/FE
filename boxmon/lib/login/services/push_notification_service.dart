import 'package:boxmon/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final String title = message.notification?.title ?? '(title 없음)';
  final String body = message.notification?.body ?? '(body 없음)';
  print("📌 [푸시알림] 🚀 [시작] 백그라운드 메시지 수신: title=$title, body=$body, data=${message.data}");
}

class PushNotificationService extends GetxService {
  Future<PushNotificationService> init() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? '새 알림';
      final body = message.notification?.body ?? '메시지를 확인해주세요.';
      print("📌 [푸시알림] ✅ [성공] 포그라운드 메시지 수신: title=$title, body=$body, data=${message.data}");
      Get.snackbar(title, body, snackPosition: SnackPosition.TOP);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📌 [푸시알림] ✅ [성공] 백그라운드 알림 탭 진입: data=${message.data}");
      _showOpenSnack(message);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("📌 [푸시알림] ✅ [성공] 종료 상태 알림 탭 진입: data=${initialMessage.data}");
        _showOpenSnack(initialMessage);
      });
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      print("📌 [푸시알림] ✅ [성공] FCM 토큰 갱신: $token");
    });

    return this;
  }

  void _showOpenSnack(RemoteMessage message) {
    final String title = message.notification?.title ?? '알림 열림';
    final String body = message.notification?.body ?? '알림을 통해 앱에 진입했습니다.';
    Get.snackbar(title, body, snackPosition: SnackPosition.TOP);
  }
}

