import 'package:boxmon/common/model/shipper_recent_shipment_model.dart';
import 'package:boxmon/common/model/shipper_shipment_summary_model.dart';
import 'package:boxmon/common/services/shipment_service.dart';
import 'package:get/get.dart';

class CommonHomeController extends GetxController {
  final ShipmentService _shipmentService = Get.find<ShipmentService>();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final summary = Rxn<ShipperShipmentSummaryModel>();
  final recentShipment = Rxn<ShipperRecentShipmentModel>();

  @override
  void onInit() {
    super.onInit();
    fetchShipperSummary();
  }

  Future<void> fetchShipperSummary() async {
    print("🚀 [시작] [화주홈요약] 요약 조회 시작");
    try {
      isLoading.value = true;
      errorMessage.value = null;
      recentShipment.value = null;

      final results = await Future.wait<dynamic>([
        _shipmentService.getShipperShipmentSummary(),
        _shipmentService.getShipperRecentShipment(),
      ]);

      final result = results[0] as ShipperShipmentSummaryModel?;
      final recentResult = results[1] as ShipperRecentShipmentModel?;
      if (result == null) {
        errorMessage.value = "배송 요약을 불러오지 못했습니다.";
        print("❌ [실패] [화주홈요약] 결과가 null 입니다.");
        return;
      }

      summary.value = result;
      recentShipment.value = recentResult;
      print(
        "✅ [성공] [화주홈요약] requested=${result.requestedCount}, assigned=${result.assignedCount}, transit=${result.inTransitCount}, done=${result.doneCount}",
      );
      if (recentResult == null) {
        print("❌ [실패] [화주최근운송] 최근 운송 데이터가 없습니다.");
      } else {
        print(
          "✅ [성공] [화주최근운송] route=${recentResult.routeText}, status=${recentResult.shipmentStatus}, updated=${recentResult.lastUpdatedLabel}",
        );
      }
    } catch (e) {
      errorMessage.value = "배송 요약을 불러오지 못했습니다.";
      print("❌ [실패] [화주홈요약] 알 수 없는 오류: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
