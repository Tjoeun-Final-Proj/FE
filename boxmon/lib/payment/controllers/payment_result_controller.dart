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
    try {
      isConfirming.value = true;

      // 💡 여기서 작성하신 API 함수를 호출합니다!
      // 토스에서 받은 paymentKey, orderId, amount를 그대로 넘겨줍니다.
      await Get.find<PaymentService>().createPayment(
        res.paymentKey,
        res.orderId,
        res.amount,
      );

      // API 내부에서 200 OK가 떨어지면 성공으로 간주
      isSuccess.value = true;
      print("✅ [Controller] 최종 승인 및 DB 저장 완료");
    } catch (e) {
      isSuccess.value = false;
      print("❌ [Controller] 승인 실패: $e");
    } finally {
      isConfirming.value = false;
    }
  }
}
