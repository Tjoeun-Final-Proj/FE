import 'package:boxmon/common/views/cargo_detail_view.dart';
import 'package:boxmon/common/views/vehicle_select_view.dart';
import 'package:boxmon/map/model/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DispatchSummaryView extends StatelessWidget {
  const DispatchSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<MapViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("일반 용달", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRouteSection(viewModel),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
            
            _buildOptionSection(
              title: "운송 정보",
              child: Obx(() => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                  child: const Icon(Icons.local_shipping, color: Color(0xFF1A2F4B)),
                ),
                title: Text(viewModel.selectedVehicle.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(viewModel.selectedVehicleDesc.value),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Get.to(() => const VehicleSelectView()),
              )),
            ),
            
            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),

            Obx(() {
              final isEntered = viewModel.pickupDateTime.value != "운송일시를 선택해주세요";
              return _buildActionTile(
                icon: Icons.calendar_today_outlined,
                title: "운송 일시",
                subtitle: viewModel.pickupDateTime.value,
                subtitleColor: isEntered ? Colors.blue : Colors.grey,
                onTap: () => _selectDateTime(context, true),
              );
            }),

            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),

            Obx(() {
              final isEntered = viewModel.deliveryDateTime.value != "도착일시를 선택해주세요";
              return _buildActionTile(
                icon: Icons.calendar_month_outlined,
                title: "도착 일시",
                subtitle: viewModel.deliveryDateTime.value,
                subtitleColor: isEntered ? Colors.blue : Colors.grey,
                onTap: () => _selectDateTime(context, false),
              );
            }),

            Obx(() => _buildActionTile(
              icon: Icons.inventory_2_outlined,
              title: "짐내용 · 요청사항 입력하기",
              subtitle: viewModel.hasElevator.value ? "엘리베이터 있음" : "계단 이용",
              onTap: () => Get.to(() => const CargoDetailView()),
            )),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("• 냉동 / 냉장 제품일 경우 선택해 주세요", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  // --- 여기서부터 모든 함수는 클래스 블록 '{' 안에 있어야 합니다 ---

  Widget _buildRouteSection(MapViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("운송 경로", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildRouteItem(Icons.radio_button_checked, Colors.blue, viewModel.startFullAddress.value),
                if (viewModel.stopover1Address.value.isNotEmpty) ...[
                  _buildRouteLine(),
                  _buildRouteItem(Icons.flag_outlined, Colors.grey, viewModel.stopover1Address.value),
                ],
                if (viewModel.stopover2Address.value.isNotEmpty) ...[
                  _buildRouteLine(),
                  _buildRouteItem(Icons.flag_outlined, Colors.grey, viewModel.stopover2Address.value),
                ],
                _buildRouteLine(),
                _buildRouteItem(Icons.location_on, Colors.red, viewModel.endFullAddress.value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteLine() {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(height: 20, child: VerticalDivider(width: 1, thickness: 1, color: Colors.grey)),
      ),
    );
  }

  Widget _buildRouteItem(IconData icon, Color color, String address) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(address.isEmpty ? "주소를 입력해주세요" : address, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildOptionSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        child,
      ]),
    );
  }

  Widget _buildActionTile({required IconData icon, required String title, required String subtitle, Color subtitleColor = Colors.blue, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 13))),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0047AB), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: const Text("운송요금 확인하기", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context, bool isPickup) async {
    final viewModel = Get.find<MapViewModel>();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ko', 'KR'),
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (pickedTime != null) {
        String formatted = viewModel.formatDateTime(pickedDate, pickedTime);
        if (isPickup) viewModel.pickupDateTime.value = formatted;
        else viewModel.deliveryDateTime.value = formatted;
      }
    }
  }
} // 클래스 끝