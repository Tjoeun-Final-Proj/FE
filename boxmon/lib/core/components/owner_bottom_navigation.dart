import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class OwnerBottomNavigation extends StatelessWidget {
  // var tokenService = TokenService();
  final int currentIndex;
  const OwnerBottomNavigation({super.key, required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(color: Colors.black, height: 0, thickness: 1),
        BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                Get.offNamed(AppRoutes.ownerHome);
                break;
              case 1:
                Get.offNamed(AppRoutes.ownerOrder);
                break;
              case 2:
                Get.toNamed(AppRoutes.ownerSetting);
                break;
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedHome05, size: 24.0),
              label: "",
            ),
            const BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedTruck, size: 24.0),
              label: "",
            ),
            const BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedMenu01, size: 24.0),
              label: "",
            ),
          ],
        ),
      ],
    );
  }
}
