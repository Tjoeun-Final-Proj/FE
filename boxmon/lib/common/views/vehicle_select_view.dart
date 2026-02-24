import 'package:boxmon/map/model/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleSelectView extends StatelessWidget {
  const VehicleSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<MapViewModel>();

    // 1. 차량 데이터를 리스트로 관리 (추가/삭제가 쉬워짐)
    final List<Map<String, String>> vehicleList = [
      {"title": "카고(오픈형)", "desc": "적재함이 개방된 일반적인 트럭", "img": "assets/img/cargo.png"},
      {"title": "탑차(박스형)", "desc": "박스 형태의 적재함으로 비바람 차단", "img": "assets/img/van.png"},
      {"title": "윙바디", "desc": "측면이 날개처럼 열려 상하차가 편리함", "img": "assets/img/wingbody.png"},
      {"title": "탱크로리", "desc": "액체 및 가스 화물 운송 전문 차량", "img": "assets/img/tanker.png"},
      {"title": "덤프 트럭", "desc": "골재 운송 및 하역에 최적화", "img": "assets/img/dump.png"},
      {"title": "벌크차(사일로)", "desc": "곡물이나 분말형 화물 운송 전문", "img": "assets/img/bulk.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("차량 선택", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      // 2. ListView.separated를 사용해 6개 아이템을 효율적으로 렌더링
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: vehicleList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final vehicle = vehicleList[index];
          return _buildVehicleCard(
            title: vehicle["title"]!,
            desc: vehicle["desc"]!,
            imagePath: vehicle["img"]!,
            onTap: () {
              viewModel.updateVehicle(vehicle["title"]!, vehicle["desc"]!);
              Get.back();
            },
          );
        },
      ),
    );
  }

  // 3. 카드 빌더 함수 수정 (레이아웃 최적화)
  Widget _buildVehicleCard({
    required String title,
    required String desc,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // 이미지 크기를 적절하게 조절 (UI가 깨지지 않게)
            SizedBox(
              width: 80, 
              height: 60,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            const SizedBox(width: 16),
            // 텍스트 영역이 길어져도 줄바꿈이 되도록 Expanded 사용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}