import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tosspayments_widget_sdk_flutter/model/paymentData.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';
import 'package:tosspayments_widget_sdk_flutter/pages/tosspayments_sdk_flutter.dart';

/// [Payment] 클래스는 결제 처리를 담당하는 위젯입니다.
class Payment extends StatelessWidget {
  /// 기본 생성자입니다.
  const Payment({super.key});
  static const String _clientKey = 'test_ck_pP2YxJ4K87aW1W6dpd7vVRGZwXLO';

  /// 위젯을 빌드합니다.
  ///
  /// '' 클라이언트 키를 사용하여 [TossPayments]를 생성합니다.
  ///
  /// 성공하면, [Get]을 이용해 결과를 R반환하고 이전 화면으로 돌아갑니다.
  /// 실패하면, [Get]을 이용해 실패 정보를 반환하고 이전 화면으로 돌아갑니다.
  @override
Widget build(BuildContext context) {
  final dynamic args = Get.arguments;

  // 1. 만약 결제 성공 데이터(Success)가 들어왔다면?
  if (args is Success) {
    return Scaffold(
      appBar: AppBar(title: const Text('결제 완료')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text("주문번호: ${args.orderId}", style: const TextStyle(fontSize: 16)),
            Text("결제 ID: ${args.paymentKey}", style: const TextStyle(fontSize: 16)),
            Text("금액: ${args.amount}원", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/'), // 홈으로 이동
              child: const Text("확인"),
            )
          ],
        ),
      ),
    );
  }

  // 2. 결제 전 요청 데이터(PaymentData)가 들어왔을 때 (기존 로직)
  try {
    final PaymentData data = args as PaymentData;
    print("🚀 [Toss SDK 요청 시작] TossPayments 위젯 생성");
    print(
      "📤 [Toss SDK Payload] "
      "method=${data.paymentMethod}, "
      "orderId=${data.orderId}, "
      "orderName=${data.orderName}, "
      "amount=${data.amount}, "
      "customerName=${data.customerName}, "
      "customerEmail=${data.customerEmail}, "
      "successUrl=${data.successUrl}, "
      "failUrl=${data.failUrl}",
    );
    print(
      "🔑 [Toss ClientKey] ${_clientKey.substring(0, 12)}... (len=${_clientKey.length})",
    );
    return TossPayments(
      clientKey: _clientKey,
      data: data,
      success: (Success success) {
        // 성공 시 자기 자신(Payment 위젯)을 다시 호출하거나 결과 페이지로 이동
        Get.offNamed(AppRoutes.resultPage, arguments: success, preventDuplicates: false);
      },
      fail: (Fail fail) {
        Get.back(result: fail);
      },
    );
  } catch (e) {
    return Scaffold(
      body: Center(child: Text("오류가 발생했습니다: $e")),
    );
  }
}
}
