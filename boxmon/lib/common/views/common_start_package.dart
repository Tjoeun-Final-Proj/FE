import 'package:boxmon/core/design/app_design.dart';
import 'package:boxmon/map/model/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class CommonStartPackageView extends StatelessWidget {
  CommonStartPackageView({super.key});
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final int totalSteps = 4; // 총 단계 수
  // 경유지 데이터를 담는 리스트 (최대 2개)
  final RxList<String> stopovers = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    // 1. 상태 및 컨트롤러 변수
    final viewModel = Get.find<MapViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "배차 요청",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. 상단 프로그레스 바
          Obx(
            () => LinearProgressIndicator(
              value: (currentPage.value + 1) / totalSteps,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryLight,
              ),
              minHeight: 6,
            ),
          ),

          // 2. 단계별 화면이 들어가는 영역 (PageView)
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(), // 스와이프 금지
              onPageChanged: (index) => currentPage.value = index,
              children: [
                _buildFirstStep(), // 1단계: 경로 입력 (함수로 분리 안 하고 안에 다 때려넣어도 됩니다)
                _buildSecondStep(), // 2단계
                _buildThirdStep(), // 3단계
                _buildFourthStep(), // 4단계
              ],
            ),
          ),

          // 3. 하단 네비게이션 버튼 (이게 핵심!)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // 이전 버튼 (첫 페이지에서는 안 보임)
                Obx(
                  () => currentPage.value == 0
                      ? const SizedBox.shrink()
                      : Expanded(
                          child: OutlinedButton(
                            onPressed: () => pageController.previousPage(
                              duration: 300.milliseconds,
                              curve: Curves.ease,
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("이전"),
                          ),
                        ),
                ),

                // 간격
                Obx(
                  () => currentPage.value == 0
                      ? const SizedBox.shrink()
                      : const SizedBox(width: 12),
                ),

                // 다음/저장 버튼
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () {
  // 1. 현재가 1번 페이지(메인)인 경우
  if (currentPage.value == 0) {
    if (viewModel.canRequestDispatch()) {
      // 출발/도착지가 다 있다면 최종 5번 페이지로 이동 (또는 다음 로직)
      print("모든 주소 입력 완료! 다음 단계로 이동");
      // 만약 5번 페이지를 만드셨다면: pageController.jumpToPage(4); 
      Get.toNamed('/dispatch/summary');
    } else {
      // 주소가 없으면 안내 메시지
      Get.snackbar("알림", "출발지와 도착지를 먼저 입력해주세요.",
          snackPosition: SnackPosition.BOTTOM);
    }
  } 
  // 2. 현재가 4번 페이지(주소 상세 입력)인 경우
  else if (currentPage.value == 3) {
    // 뷰모델에 저장하고 다시 1번 페이지로 복귀
    viewModel.confirmAddressSelection(pageController);
  } 
  // 3. 그 외 (2, 3단계 검색/지도 화면)
  else if (currentPage.value < totalSteps - 1) {
    pageController.nextPage(
      duration: 300.milliseconds,
      curve: Curves.ease,
    );
  } 
  // 4. 마지막 페이지인 경우
  else {
    Get.back();
  }
},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        minimumSize: const Size(0, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        currentPage.value < totalSteps - 1 ? "입력 완료" : "요청 완료",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 1단계: 경로 입력 (함수 제거 버전) ---
  Widget _buildFirstStep() {

    final viewModel = Get.find<MapViewModel>(); // 뷰모델 가져오기

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            "어디로 짐을 옮기시나요?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          const Text(
            "운송 경로",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),

          // --- 경로 입력 박스 ---
          Obx(
            () => Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // 1. 출발지 행 (🔥 수정됨: GestureDetector 추가)
                  GestureDetector(
                    onTap: () => viewModel.startAddressSetup(AddressType.start, pageController),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedCar03,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              // 🔥 데이터가 있으면 주소 표시, 없으면 힌트 표시
                              viewModel.startFullAddress.value.isEmpty 
                                  ? "출발지" 
                                  : viewModel.startFullAddress.value,
                              style: TextStyle(
                                color: viewModel.startFullAddress.value.isEmpty ? Colors.grey : Colors.black,
                                fontSize: 16,
                                fontWeight: viewModel.startFullAddress.value.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. 추가된 경유지 리스트 (🔥 수정됨: 클릭 시 편집 가능하게)
                  ...stopovers.asMap().entries.map((entry) {
                    int idx = entry.key;
                    return Column(
                      children: [
                        Divider(height: 1, color: Colors.grey.shade300, indent: 55),
                        GestureDetector(
                          onTap: () => viewModel.startAddressSetup(
                            idx == 0 ? AddressType.stopover1 : AddressType.stopover2, 
                            pageController
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            child: Row(
                              children: [
                                const HugeIcon(icon: HugeIcons.strokeRoundedFlag01, color: Colors.black, size: 24.0),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    // 🔥 경유지 데이터 바인딩
                                    (idx == 0 ? viewModel.stopover1Address.value : viewModel.stopover2Address.value).isEmpty
                                        ? "경유지 ${idx + 1}"
                                        : (idx == 0 ? viewModel.stopover1Address.value : viewModel.stopover2Address.value),
                                    style: TextStyle(
                                      color: (idx == 0 ? viewModel.stopover1Address.value : viewModel.stopover2Address.value).isEmpty 
                                          ? Colors.grey : Colors.black,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                                  onPressed: () {
                                    stopovers.removeAt(idx);
                                    // 삭제 시 뷰모델 데이터도 비워주기
                                    if(idx == 0) viewModel.stopover1Address.value = "";
                                    else viewModel.stopover2Address.value = "";
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  Divider(height: 1, color: Colors.grey.shade300, indent: 55),

                  // 3. 도착지 행 (🔥 수정됨: GestureDetector 추가)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        const HugeIcon(icon: HugeIcons.strokeRoundedCar04, color: Colors.black, size: 24.0),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.startAddressSetup(AddressType.end, pageController),
                            child: Text(
                              // 🔥 데이터 바인딩
                              viewModel.endFullAddress.value.isEmpty ? "도착지" : viewModel.endFullAddress.value,
                              style: TextStyle(
                                color: viewModel.endFullAddress.value.isEmpty ? Colors.grey : Colors.black,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        if (stopovers.length < 2)
                          GestureDetector(
                            onTap: () => stopovers.add("새 경유지"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                              child: const Text("경유지 +", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "※ 경유지 버튼을 클릭하면, 경유지를 추가 할 수 있습니다.",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(PageController pc, RxInt current, int total) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Obx(
            () => current.value == 0
                ? const SizedBox.shrink()
                : Expanded(
                    child: OutlinedButton(
                      onPressed: () => pc.previousPage(
                        duration: 300.milliseconds,
                        curve: Curves.ease,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("이전"),
                    ),
                  ),
          ),
          Obx(
            () => current.value == 0
                ? const SizedBox.shrink()
                : const SizedBox(width: 12),
          ),
          Expanded(
            child: Obx(
              () => ElevatedButton(
                onPressed: () => current.value < total - 1
                    ? pc.nextPage(
                        duration: 300.milliseconds,
                        curve: Curves.ease,
                      )
                    : Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  minimumSize: const Size(0, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  current.value < total - 1 ? "다음" : "요청 완료",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildSecondStep() {
  final viewModel = Get.find<MapViewModel>();

  return Column(
    children: [
      // 1. 검색창
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: "지번, 도로명, 건물명으로 검색",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onSubmitted: (value) async {
            // 🔥 여기서 바로 페이지를 넘기지 말고, 검색 결과만 불러옵니다.
            await viewModel.searchLocation(value);
          },
        ),
      ),

      // 2. 검색 결과 리스트 영역
      Expanded(
        child: Obx(() {
          if (viewModel.isSearching.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return ListView.builder(
            itemCount: viewModel.searchResults.length,
            itemBuilder: (context, index) {
              final item = viewModel.searchResults[index];
              return ListTile(
                title: Text(item.title), // 건물명 (ex. 강남역 2호선)
                subtitle: Text(item.address), // 전체 주소
                onTap: () {
                  // 🔥 사용자가 실제 장소를 "선택"했을 때만 지도로 이동!
                  viewModel.selectLocation(item); 
                  print("📌 [LOG 7] 지도 화면으로 이동");
  
  // 2. PageView의 다음 페이지(지도 화면)로 이동
  pageController.nextPage(
    duration: const Duration(milliseconds: 300), 
    curve: Curves.ease
  );
                },
              );
            },
          );
        }),
      ),
      
      // 3. 현재 위치로 찾기 (하단 고정 혹은 리스트 위에 배치)
      TextButton(
        onPressed: () => viewModel.useCurrentLocation(),
        child: const Text("현재 위치로 찾기", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ],
  );
}
// 1. 카드는 오직 "주소 정보"만 보여주는 역할만 합니다.
Widget _buildAddressCard(MapViewModel viewModel) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, // 중요: 내용물만큼만 높이 차지
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "선택된 위치",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Text(
          viewModel.currentAddress.value, // 뷰모델의 현재 주소 바인딩
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          "지도를 움직여 위치를 조정할 수 있습니다.",
          style: TextStyle(color: AppColors.primaryLight, fontSize: 12),
        ),
      ],
    ),
  );
}

// 2. 여기서 Stack 구조를 잡아줍니다.
Widget _buildThirdStep() {
  final MapViewModel viewModel = Get.find<MapViewModel>();

  return Obx(() => Stack(
    children: [
      // 배경: 메인 지도 (이거 하나면 충분합니다!)
      NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: viewModel.targetLocation.value,
            zoom: 16,
          ),
          locationButtonEnable: true,
        ),
        onMapReady: (controller) => viewModel.onMapReady(controller),
        onMapTapped: (point, latLng) => viewModel.handleMapTap(latLng),
        onSymbolTapped: (symbol) => viewModel.handleMapTap(symbol.position, buildingName: symbol.caption),
      ),

      // 위층: 주소 카드 (Positioned는 Stack의 직계 자식이어야 함!)
      if (viewModel.currentAddress.value.isNotEmpty)
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: _buildAddressCard(viewModel), // 수정된 카드 위젯
        ),

      // 최상단: 로딩바
      if (viewModel.isLoading.value)
        const Center(child: CircularProgressIndicator(color: Color(0xFF1A2F4B))),
    ],
  ));
}
Widget _buildFourthStep() {
  final MapViewModel viewModel = Get.find<MapViewModel>();

  return Obx(() {
    // 1. 현재 주소 타입 상태값들을 Obx 내부에서 정의
    final currentType = viewModel.activeType.value;
    final bool isStart = currentType == AddressType.start;
    final bool isEnd = currentType == AddressType.end;

    String contactTitle = "";
    switch (viewModel.activeType.value) {
      case AddressType.start:
        contactTitle = "출발지 연락처 정보";
        break;
      case AddressType.stopover1:
        contactTitle = "경유지 1 연락처 정보";
        break;
      case AddressType.stopover2:
        contactTitle = "경유지 2 연락처 정보";
        break;
      case AddressType.end:
        contactTitle = "도착지 연락처 정보";
        break;
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 주소 조회 및 수정 버튼
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    viewModel.currentAddress.value,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                TextButton(
                  onPressed: () => pageController.animateToPage(1,
                      duration: 300.milliseconds, curve: Curves.ease),
                  child: const Text("수정", style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. 상세 주소 입력 (동, 호수 등)
          TextField(
            controller: viewModel.detailAddressController,
            decoration: InputDecoration(
              hintText: "상세 주소를 입력해주세요 (예: 101동 501호)",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            ),
          ),
          const SizedBox(height: 12),

          // 🔥 3. 중량 입력 (출발지일 때만 표시)
          if (isStart) ...[
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "중량을 입력해주세요...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: "톤",
                    underline: const SizedBox(),
                    items: ["톤", "kg"]
                        .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // 5. 엘리베이터 유무 토글
          Row(
            children: [
              _buildElevatorButton(viewModel, true, "엘리베이터 있음"),
              const SizedBox(width: 8),
              _buildElevatorButton(viewModel, false, "계단만 있음"),
            ],
          ),

          const Divider(height: 40),

          // 🔥 6. 연락처 정보 (문구 동적 변경)
          Text(
            isStart ? "출발지 연락처 정보" : "도착지 연락처 정보",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline),
              hintText: "이름",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_android_outlined),
              hintText: "휴대전화번호",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 30),

          // 7. 최종 완료 버튼
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => viewModel.confirmAddressSelection(pageController),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0047AB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("주소 입력 완료",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  });
  }

}

// 엘리베이터 버튼 중복 코드 방지를 위한 헬퍼 위젯
Widget _buildElevatorButton(MapViewModel viewModel, bool value, String label) {
  final bool isSelected = viewModel.hasElevator.value == value;
  return Expanded(
    child: GestureDetector(
      onTap: () => viewModel.hasElevator.value = value,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0047AB) : Colors.white,
          border: Border.all(color: const Color(0xFF0047AB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF0047AB),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
