import 'package:boxmon/owner/controllers/vehicle_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleRegisterView extends StatelessWidget {
  const VehicleRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 컨트롤러를 여기서 put 해야 에러가 안 납니다.
    final controller = Get.put(VehicleRegisterController());

    // 💡 데이터 리스트는 빌드 시점에 한 번만 생성되도록 Obx 밖에 둡니다.
    final List<Map<String, dynamic>> vehicleTypes = [
      {"code": "CARGO", "name": "카고", "img": "assets/img/cargo.png"},
      {"code": "VAN", "name": "탑차", "img": "assets/img/van.png"},
      {"code": "WINGBODY", "name": "윙바디", "img": "assets/img/wingbody.png"},
      {"code": "TANKER", "name": "탱크로리", "img": "assets/img/tanker.png"},
      {"code": "DUMP", "name": "덤프", "img": "assets/img/dump.png"},
      {"code": "BULK", "name": "벌크", "img": "assets/img/bulk.png"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("차량 등록", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("기본 정보 입력"),
            _buildInput(controller.vehicleNumberController, "차량 번호", "예: 12가 3456", Icons.format_list_numbered),
            const SizedBox(height: 16),
            _buildInput(controller.weightController, "적재 중량 (톤)", "예: 1.0", Icons.monitor_weight_outlined, isNumber: true),
            
            const SizedBox(height: 32),
            _buildSectionTitle("차량 종류 선택"),
            
            // 🎯 빨간 에러 방지 포인트: Obx는 업데이트가 필요한 그리드 영역만 감쌉니다.
            // 🎯 1. GridView 전체를 Obx로 감싸기 전에 데이터가 있는지 먼저 확인
Obx(() {
  // 💡 팁: .value를 Obx 최상단에서 한 번 읽어주면 '감시 대상'으로 확실히 등록됩니다.
  final selectedType = controller.vehicleType.value;
  
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
    ),
    itemCount: vehicleTypes.length,
    itemBuilder: (context, index) {
      final type = vehicleTypes[index];
      // ✅ 여기서 selectedType(이미 .value를 읽은 값)을 사용하거나
      // ✅ controller.vehicleType.value를 직접 비교합니다.
      final isSelected = controller.vehicleType.value == type['code'];

      return _buildSelectCard(
        label: type['name'],
        imagePath: type['img'],
        isSelected: isSelected,
        onTap: () {
          // 클릭 시 .value에 직접 값을 할당
          controller.vehicleType.value = type['code'];
        },
      );
    },
  );
}),

            const SizedBox(height: 32),
            _buildSectionTitle("특수 옵션 (중복 선택 가능)"),
            Obx(() => Row(
              children: [
                _buildOptionBtn(
                  "냉동 가능", Icons.ac_unit, controller.isFrozen.value, 
                  () => controller.isFrozen.value = !controller.isFrozen.value, Colors.blue
                ),
                const SizedBox(width: 12),
                _buildOptionBtn(
                  "냉장 가능", Icons.kitchen_outlined, controller.isRefrigerated.value, 
                  () => controller.isRefrigerated.value = !controller.isRefrigerated.value, Colors.cyan
                ),
              ],
            )),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(controller),
    );
  }

  // --- 위젯 헬퍼 함수들 (디자인 최적화) ---

  Widget _buildSelectCard({required String label, required String imagePath, required bool isSelected, required VoidCallback onTap}) {
    final activeColor = const Color(0xFF0047AB);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? activeColor : Colors.grey.shade100, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40, child: Image.asset(imagePath, fit: BoxFit.contain)),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(
              color: isSelected ? activeColor : Colors.black87, 
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, 
              fontSize: 15
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, String hint, IconData icon, {bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(
          labelText: label, hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildOptionBtn(String label, IconData icon, bool isSelected, VoidCallback onTap, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 70,
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? color : Colors.grey.shade100, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? color : Colors.grey[400], size: 20),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: isSelected ? color : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(VehicleRegisterController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : () => controller.submit(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0047AB),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: controller.isLoading.value
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("차량 등록 완료", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      )),
    );
  }
}