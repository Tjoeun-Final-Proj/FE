import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/owner_bottom_navigation.dart';
import 'package:boxmon/owner/controllers/owner_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class OwnerHomeView extends StatelessWidget {
  const OwnerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 컨트롤러 주입
    final controller = Get.put(OwnerHomeController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavBar(),
      bottomNavigationBar: OwnerBottomNavigation(currentIndex: 0),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            const Text(
              "관리자님",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text(
              "오늘 어떤 물건을 보내실 건가요?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 10),

            // ⭐ 메뉴 버튼 3개 전부 직작성
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// 배차 요청
                InkWell(
                  onTap: () => Get.toNamed('/common/start/package'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: const Color(0xFF434343),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedPackageSearch,
                          color: Colors.white,
                          size: 49,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "배차 검색",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 운송 현황
                InkWell(
                  onTap: () => Get.toNamed('/driver/inventory'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedTruck,
                          color: Colors.black87,
                          size: 49,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "운송 현황",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 정산 관리
                InkWell(
                  onTap: () => Get.toNamed('/owner/wallet'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedWallet02,
                          color: Colors.black87,
                          size: 49,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "정산 관리",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: NaverMap(
  options: const NaverMapViewOptions(
    locationButtonEnable: true,    // 내 위치 버튼 활성화
    indoorEnable: true,           // 실내지도 활성화
    consumeSymbolTapEvents: false,
    initialCameraPosition: NCameraPosition(
      target: NLatLng(37.5665, 126.9780),
      zoom: 15,
    ),
  ),
  onMapReady: (location) {
    print("🗺️ [View] 네이버 지도가 준비되었습니다.");
    // 컨트롤러의 함수 호출
    controller.onMapReady(location);
  },
  
  onMapTapped: (point, latLng) {
    print("📍 [View] 지도 클릭됨: ${latLng.latitude}, ${latLng.longitude}");
  },
),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
