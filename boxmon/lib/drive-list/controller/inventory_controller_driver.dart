import 'package:boxmon/drive-list/model/inventory_model.dart';
import 'package:boxmon/drive-list/services/inventory_service.dart';
import 'package:get/get.dart';

class InventoryControllerWithDriver extends GetxController {
  final InventoryService _inventoryService = Get.find<InventoryService>();

  // 🎯 1. 타입을 InventoryModel로 변경
  var inventoryList = <InventoryModel>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataWithDriver(); // 🎯 뷰가 켜지자마자 화주 오더 조회
  }

  Future<void> fetchDataWithDriver() async {
    try {
      isLoading.value = true;
      final result = await _inventoryService.driverinventory(); // 화주 서비스 호출
      inventoryList.assignAll(result ?? []);
    } finally {
      isLoading.value = false;
    }
  }

  // 🎯 4. View에서 RefreshIndicator로 호출할 함수 (추가)
  Future<void> onRefresh() async {
    await fetchDataWithDriver();
  }
}
