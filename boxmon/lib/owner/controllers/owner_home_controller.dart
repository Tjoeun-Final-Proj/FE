import 'package:boxmon/drive-list/model/inventory_model.dart';
import 'package:boxmon/drive-list/services/inventory_service.dart';
import 'package:boxmon/owner/model/driver_shipment_summary_model.dart';
import 'package:boxmon/owner/services/order_shipment_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OwnerHomeController extends GetxController {
  final OrderShipmentServices _orderShipmentServices =
      Get.find<OrderShipmentServices>();
  final InventoryService _inventoryService = Get.find<InventoryService>();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final summary = Rxn<DriverShipmentSummaryModel>();
  final nextShipment = Rxn<InventoryModel>();

  @override
  void onInit() {
    super.onInit();
    fetchTodaySummary();
  }

  Future<void> fetchTodaySummary() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      nextShipment.value = null;

      final results = await Future.wait<dynamic>([
        _orderShipmentServices.getDriverTodaySummary(),
        _inventoryService.driverinventory(),
      ]);

      final result = results[0] as DriverShipmentSummaryModel?;
      final inventoryList = results[1] as List<InventoryModel>?;
      if (result == null) {
        errorMessage.value = "오늘의 운송 요약을 불러오지 못했습니다.";
        return;
      }

      summary.value = result;
      if (inventoryList != null && inventoryList.isNotEmpty) {
        nextShipment.value = _selectNextShipment(inventoryList);
      }
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

  bool get hasNextShipment => nextShipment.value != null;

  int? get nextShipmentId => nextShipment.value?.shipmentId;

  String get nextRouteText {
    final InventoryModel? item = nextShipment.value;
    if (item == null) return "다음 운송이 없습니다";
    final pickup = (item.pickupAddress == null || item.pickupAddress!.isEmpty)
        ? "출발지 미정"
        : item.pickupAddress!;
    final dropoff = (item.dropoffAddress == null || item.dropoffAddress!.isEmpty)
        ? "도착지 미정"
        : item.dropoffAddress!;
    return "$pickup → $dropoff";
  }

  String get nextStatusText {
    final status = nextShipment.value?.shipmentStatus;
    if (status == null || status.trim().isEmpty) return "상태 미정";
    return status.trim();
  }

  String get nextPickupText {
    final DateTime? pickup = nextShipment.value?.pickupDesiredAt;
    if (pickup == null) return "상차 시간 미정";
    final now = DateTime.now();
    final isToday =
        now.year == pickup.year &&
        now.month == pickup.month &&
        now.day == pickup.day;

    if (isToday) {
      return "오늘 ${DateFormat('HH:mm').format(pickup)} 상차 예정";
    }
    return "${DateFormat('MM/dd HH:mm').format(pickup)} 상차 예정";
  }

  InventoryModel? _selectNextShipment(List<InventoryModel> list) {
    final candidates = list
        .where((item) => !_isTerminalStatus(item.shipmentStatus))
        .toList();
    if (candidates.isEmpty) return null;

    candidates.sort((a, b) {
      final aPickup = a.pickupDesiredAt;
      final bPickup = b.pickupDesiredAt;
      if (aPickup == null && bPickup == null) return 0;
      if (aPickup == null) return 1;
      if (bPickup == null) return -1;
      return aPickup.compareTo(bPickup);
    });

    return candidates.first;
  }

  bool _isTerminalStatus(String? status) {
    if (status == null) return false;
    final normalized = status.trim().toUpperCase();
    return normalized == "DONE" ||
        normalized == "CANCELED" ||
        normalized == "CANCELLED" ||
        status.contains("완료") ||
        status.contains("취소");
  }
}
