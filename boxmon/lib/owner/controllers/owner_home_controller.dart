import 'package:boxmon/owner/model/driver_shipment_summary_model.dart';
import 'package:boxmon/owner/services/order_shipment_services.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class OwnerHomeController extends GetxController {
  final OrderShipmentServices _orderShipmentServices =
      Get.find<OrderShipmentServices>();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final summary = Rxn<DriverShipmentSummaryModel>();

  @override
  void onInit() {
    super.onInit();
    fetchTodaySummary();
  }

  Future<void> fetchTodaySummary() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await _orderShipmentServices.getDriverTodaySummary();
      if (result == null) {
        errorMessage.value = "오늘의 운송 요약을 불러오지 못했습니다.";
        return;
      }

      summary.value = result;
      print(
        "✅ [성공] [차주홈요약] today=${result.todayScheduleCount}, transit=${result.inTransitCount}, first=${result.firstPickupDesiredAt}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  String get firstPickupText {
    final DateTime? first = summary.value?.firstPickupDesiredAt;
    if (first == null) return "첫 상차 미정";
    return "첫 상차 ${DateFormat('HH:mm').format(first)}";
  }
}
