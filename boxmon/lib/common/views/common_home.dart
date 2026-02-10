import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/common_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:hugeicons/hugeicons.dart';

class CommonHomeView extends StatelessWidget {
  const CommonHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(),
      body: Center(child: Column(
        children: [
          Text("은섭님 ㅎㅇㅎㅇ"),
          Text("오늘 어떤 물건을 보내실 건가요?"),
          Row(
            children: [
Expanded(
  flex: 1,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0), // 버튼 사이 간격
    child: InkWell(
      onTap: () {
        print("배차 요청 클릭됨!");
      },
      borderRadius: BorderRadius.circular(10), // 클릭 효과 범위
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 배경색
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFD1D1D1)), // 테두리
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedInvoice01,
              color: Colors.grey[800],
              size: 49.0, // 아이콘 크기
            ),
            const SizedBox(height: 10), // 아이콘과 글자 사이 간격
            const Text(
              "배차 요청",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
Expanded(
  flex: 1,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0), // 버튼 사이 간격
    child: InkWell(
      onTap: () {
        print("배차 요청 클릭됨!");
      },
      borderRadius: BorderRadius.circular(10), // 클릭 효과 범위
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 배경색
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFD1D1D1)), // 테두리
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedInvoice01,
              color: Colors.grey[800],
              size: 49.0, // 아이콘 크기
            ),
            const SizedBox(height: 10), // 아이콘과 글자 사이 간격
            const Text(
              "배차 요청",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
Expanded(
  flex: 1,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0), // 버튼 사이 간격
    child: InkWell(
      onTap: () {
        print("배차 요청 클릭됨!");
      },
      borderRadius: BorderRadius.circular(10), // 클릭 효과 범위
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 배경색
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFD1D1D1)), // 테두리
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedInvoice01,
              color: Colors.grey[800],
              size: 49.0, // 아이콘 크기
            ),
            const SizedBox(height: 10), // 아이콘과 글자 사이 간격
            const Text(
              "배차 요청",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
],
          ),
          const Expanded(
        child: NaverMap(),
      ),
        ],
      )),
      // 속성 이름을 bottomNavigationBar로 수정하세요!
      bottomNavigationBar: CommonBottomNavigation(currentIndex: 0),
    );
  }
}