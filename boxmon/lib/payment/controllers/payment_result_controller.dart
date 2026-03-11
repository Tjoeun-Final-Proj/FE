import 'package:boxmon/payment/services/payment_service.dart';
import 'package:get/get.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

class PaymentResultController extends GetxController {
  final Success res = Get.arguments as Success; // 토스에서 넘어온 결과
  final PaymentService _paymentService = Get.find<PaymentService>();

  var isConfirming = true.obs; // 로딩 중 상태
  var isSuccess = false.obs; // 승인 성공 여부

  @override
  void onInit() {
    super.onInit();
    _handlePaymentConfirm();
  }

  Future<void> _handlePaymentConfirm() async {
    isConfirming.value = true;
    try {
      final result = await _paymentService.createPayment(
        res.paymentKey,
        res.orderId,
        res.amount,
      );

      if (result != null) {
        isSuccess.value = true;
        print("✅ [Controller] 최종 승인 및 DB 저장 완료");
      } else {
        isSuccess.value = false;
        print("❌ [Controller] 승인 실패: 서버 응답이 null 입니다.");
      }
    } catch (e) {
      isSuccess.value = false;
      print("❌ [Controller] 승인 실패: $e");
    } finally {
      isConfirming.value = false;
    }
  }
}
