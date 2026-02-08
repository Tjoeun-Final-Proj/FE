import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class CommonBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CommonBottomNavigation({super.key, required this.currentIndex});
  // var tokenService = TokenService();
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
                Get.offNamed(AppRoutes.commonHome);
                break;
              case 1:
                Get.offNamed(AppRoutes.commonOrder);
                break;
              case 2:
                Get.toNamed(AppRoutes.commonSetting);
                break;
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedHome05, size: 24.0),
              label: "",
            ),
            const BottomNavigationBarItem(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedDocumentValidation,
                size: 24.0,
              ),
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
