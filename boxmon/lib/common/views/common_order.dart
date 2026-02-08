import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/common_bottom_navigation.dart';
import 'package:flutter/material.dart';

class CommonOrderView extends StatelessWidget {
  const CommonOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(),
      body: const Center(child: Text("Hello 나는 공통 주문이야")),
      // 속성 이름을 bottomNavigationBar로 수정하세요!
      bottomNavigationBar: CommonBottomNavigation(currentIndex: 1),
    );
  }
}
