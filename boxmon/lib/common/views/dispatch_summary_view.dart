import 'package:boxmon/common/controller/shipment_controller.dart';
import 'package:boxmon/common/model/shipment_model.dart';
import 'package:boxmon/common/views/cargo_detail_view.dart';
import 'package:boxmon/common/views/vehicle_select_view.dart';
import 'package:boxmon/map/model/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // 숫자 포맷팅을 위한 패키지

class DispatchSummaryView extends StatelessWidget {
  const DispatchSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<MapViewModel>();
    final controller = Get.put(ShipmentController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "일반 용달",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
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
              child: Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_shipping,
                      color: Color(0xFF1A2F4B),
                    ),
                  ),
                  title: Text(
                    viewModel.selectedVehicle.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(viewModel.selectedVehicleDesc.value),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.to(() => const VehicleSelectView()),
                ),
              ),
            ),

            const Divider(height: 20),

            Obx(() {
              final isEntered =
                  viewModel.pickupDateTime.value != "운송일시를 선택해주세요";
              return _buildActionTile(
                icon: Icons.calendar_today_outlined,
                title: "운송 일시",
                subtitle: viewModel.pickupDateTime.value,
                subtitleColor: isEntered ? Colors.blue : Colors.grey,
                onTap: () => _selectDateTime(context, true),
              );
            }),

            const Divider(height: 20),

            Obx(() {
              final isEntered =
                  viewModel.deliveryDateTime.value != "도착일시를 선택해주세요";
              return _buildActionTile(
                icon: Icons.calendar_month_outlined,
                title: "도착 일시",
                subtitle: viewModel.deliveryDateTime.value,
                subtitleColor: isEntered ? Colors.blue : Colors.grey,
                onTap: () => _selectDateTime(context, false),
              );
            }),
            const Divider(height: 20),
            Obx(
              () => _buildActionTile(
                icon: Icons.inventory_2_outlined,
                title: "짐내용 · 요청사항 입력하기",
                subtitle: viewModel.hasElevator.value ? "엘리베이터 있음" : "계단 이용",
                onTap: () => Get.to(() => const CargoDetailView()),
              ),
            ),
            const Divider(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "• 냉동 / 냉장 제품일 경우 선택해 주세요",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Obx(
                () => Row(
                  // Obx로 감싸서 상태 변화 감지
                  children: [
                    _buildTempButton(viewModel, TempType.frozen, "냉동 제품"),
                    const SizedBox(width: 8),
                    _buildTempButton(viewModel, TempType.refrigerated, "냉장 제품"),
                  ],
                ),
              ),
            ),
            const Divider(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "• 희망 운송요금",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: viewModel.priceController,
                keyboardType: TextInputType.number, // 🔢 숫자 키보드 호출
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                decoration: InputDecoration(
                  hintText: "금액을 입력해주세요",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  suffixText: "원", // 뒤에 '원' 표시
                  suffixStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  // 테두리 디자인
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                // 숫자가 바뀔 때마다 콤마 처리 로직을 넣고 싶다면 아래 참고
                onChanged: (value) {
                  if (value.isEmpty) return;

                  // 1. 기존 콤마 제거 (숫자만 추출)
                  String content = value.replaceAll(',', '');

                  // 2. 숫자로 변환 후 콤마 추가 포맷팅
                  final formatter = NumberFormat('#,###');
                  String formatted = formatter.format(int.parse(content));

                  // 3. 텍스트 필드 업데이트 및 커서 위치 조정
                  viewModel.priceController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(
                      offset: formatted.length,
                    ),
                  );
                },
              ),
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
          const Text(
            "운송 경로",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildRouteItem(
                  Icons.radio_button_checked,
                  Colors.blue,
                  viewModel.startFullAddress.value,
                ),
                if (viewModel.stopover1Address.value.isNotEmpty) ...[
                  _buildRouteLine(),
                  _buildRouteItem(
                    Icons.flag_outlined,
                    Colors.grey,
                    viewModel.stopover1Address.value,
                  ),
                ],
                if (viewModel.stopover2Address.value.isNotEmpty) ...[
                  _buildRouteLine(),
                  _buildRouteItem(
                    Icons.flag_outlined,
                    Colors.grey,
                    viewModel.stopover2Address.value,
                  ),
                ],
                _buildRouteLine(),
                _buildRouteItem(
                  Icons.location_on,
                  Colors.red,
                  viewModel.endFullAddress.value,
                ),
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
        child: SizedBox(
          height: 20,
          child: VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildRouteItem(IconData icon, Color color, String address) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            address.isEmpty ? "주소를 입력해주세요" : address,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color subtitleColor = Colors.blue,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(color: subtitleColor, fontSize: 13),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildBottomButton() {
    // 1. 필요한 컨트롤러들 찾아오기
    final viewModel = Get.find<MapViewModel>();
    final shipmentController = Get.find<ShipmentController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Obx(
        () => ElevatedButton(
          // 로딩 중일 때는 버튼 클릭 방지
          onPressed: shipmentController.isLoading.value
              ? null
              : () async {
                  try {
                    print("📝 [UI] 배송 요청 데이터 조립 시작...");

                    // 2. 가격 데이터 가공 (콤마 제거 후 int 변환)
                    final String priceText = viewModel.priceController.text
                        .replaceAll(',', '');
                    final int finalPrice = int.tryParse(priceText) ?? 0;

                    // 3. 날짜 데이터 가공 (DateTime 객체로 변환)
                    // 뷰모델의 pickupDateRaw를 사용하거나 문자열을 파싱합니다.
                    DateTime pickupDate =
                        viewModel.pickupDateRaw.value ?? DateTime.now();
                    DateTime deliveryDate =
                        viewModel.deliveryDateRaw.value ??
                        DateTime.now().add(const Duration(hours: 3));

                    // 4. ShipmentModel 생성 (서버 전송 규격에 맞춤)
                    final requestModel = ShipmentModel(
                      // 출발지
                      pickupPoint: {
                        "x": viewModel.startLng.value,
                        "y": viewModel.startLat.value,
                      },
                      pickupAddress: viewModel.startFullAddress.value,
                      pickupDesiredAt: pickupDate,

                      // 도착지
                      dropoffPoint: {
                        "x": viewModel.endLng.value,
                        "y": viewModel.endLat.value,
                      },
                      dropoffAddress: viewModel.endFullAddress.value,
                      dropoffDesiredAt: deliveryDate,

                      // 경유지 1 (있을 때만 포함)
                      waypoint1Point:
                          viewModel.stopover1Address.value.isNotEmpty
                          ? {
                              "x": viewModel.stop1Lng.value,
                              "y": viewModel.stop1Lat.value,
                            }
                          : null,
                      waypoint1Address:
                          viewModel.stopover1Address.value.isNotEmpty
                          ? viewModel.stopover1Address.value
                          : null,

                      // 경유지 2 (있을 때만 포함)
                      waypoint2Point:
                          viewModel.stopover2Address.value.isNotEmpty
                          ? {
                              "x": viewModel.stop2Lng.value,
                              "y": viewModel.stop2Lat.value,
                            }
                          : null,
                      waypoint2Address:
                          viewModel.stopover2Address.value.isNotEmpty
                          ? viewModel.stopover2Address.value
                          : null,

                      // 기타 운송 정보
                      price: finalPrice,
                      vehicleType: viewModel
                          .selectedVehicleType
                          .value
                          .name, // Enum의 이름을 문자열로 전송
                      // 온도 관리 옵션
                      needRefrigerate:
                          viewModel.selectedTempType.value ==
                          TempType.refrigerated,
                      needFreeze:
                          viewModel.selectedTempType.value == TempType.frozen,

                      // 🔥 [중요] 서버 에러 해결을 위한 필수값 매핑
                      cargoType: "GENERAL", // 서버 Enum에 있는 값인지 확인 필요!
                      cargoWeight:
                          double.tryParse(viewModel.weightController.text) ??
                          1.0, // null 방지
                      cargoVolume: viewModel.widthController.text,

                      description: viewModel.cargoDescription.value, // 상세 요청사항
                      companyName:
                          viewModel.companyNameController.text.isNotEmpty
                          ? viewModel.companyNameController.text
                          : "개인",

                      // 🔥 진짜 사진 파일 전달
                      files: viewModel.selectedCargoImage.value,
                    );

                    // 5. 컨트롤러 호출 (서버 전송 실행)
                    await shipmentController.submitShipment(
                      requestModel,
                      files: viewModel.selectedCargoImage.value,
                    );
                  } catch (e) {
                    print("❌ [UI Error] 데이터 조립 중 에러: $e");
                    Get.snackbar("알림", "입력 정보를 다시 확인해주세요.");
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0047AB),
            disabledBackgroundColor: Colors.grey, // 로딩 중 버튼 색상
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: shipmentController.isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "운송요금 확인하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
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
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        String formatted = viewModel.formatDateTime(pickedDate, pickedTime);
        if (isPickup)
          viewModel.pickupDateTime.value = formatted;
        else
          viewModel.deliveryDateTime.value = formatted;
      }
    }
  }
} // 클래스 끝

Widget _buildTempButton(MapViewModel viewModel, TempType type, String label) {
  final bool isSelected = viewModel.selectedTempType.value == type;

  // 타입에 따른 아이콘과 색상 설정
  IconData icon = type == TempType.frozen ? Icons.ac_unit : Icons.opacity;
  Color activeColor = type == TempType.frozen
      ? Colors.blue.shade800
      : Colors.cyan.shade600;

  return Expanded(
    child: GestureDetector(
      onTap: () =>
          viewModel.selectedTempType.value = isSelected ? TempType.none : type,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // 선택 시 부드러운 전환
        height: 65, // 높이를 살짝 키워 시원하게 만듦
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(15), // 더 둥글게
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isSelected ? activeColor : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

