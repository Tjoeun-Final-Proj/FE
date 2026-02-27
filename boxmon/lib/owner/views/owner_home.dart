import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/owner_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class OwnerHomeView extends StatelessWidget {
  const OwnerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
                      color: const Color(0xFF1F5AA6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedInvoice01,
                          color: Colors.white,
                          size: 49,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "배차 요청",
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
                  onTap: () => print("운송 현황 클릭"),
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
                  child: const NaverMap(),
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
