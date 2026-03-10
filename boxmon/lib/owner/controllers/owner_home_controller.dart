import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

class OwnerHomeController extends GetxController {
  late NaverMapController mapController;

  void onMapReady(NaverMapController controller) {
    mapController = controller;
    print("🛠️ [Controller] 지도 준비 완료");
    mapController.setLocationTrackingMode(NLocationTrackingMode.follow);
    mapController.getLocationOverlay().setIsVisible(true);
  }
}
