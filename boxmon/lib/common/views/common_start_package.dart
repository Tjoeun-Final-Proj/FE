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
                        if (currentPage.value < totalSteps - 1) {
                          // 다음 페이지로 이동
                          pageController.nextPage(
                            duration: 300.milliseconds,
                            curve: Curves.ease,
                          );
                        } else {
                          // 최종 완료 처리
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
                        currentPage.value < totalSteps - 1 ? "다음" : "요청 완료",
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
                  // 1. 출발지 행 (생코드로 직접 구현)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedCar03,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "출발지",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. 추가된 경유지 리스트 (최대 2개)
                  ...stopovers.asMap().entries.map((entry) {
                    int idx = entry.key;
                    return Column(
                      children: [
                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                          indent: 55,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                          child: Row(
                            children: [
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedFlag01,
                                color: Colors.black,
                                size: 24.0,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "경유지 ${idx + 1}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => stopovers.removeAt(idx),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),

                  Divider(height: 1, color: Colors.grey.shade300, indent: 55),

                  // 3. 도착지 행
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedCar04,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "도착지",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),

                        // 경유지 추가 버튼
                        if (stopovers.length < 2)
                          GestureDetector(
                            onTap: () => stopovers.add("새 경유지"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "경유지 +",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            "경유지 버튼을 클릭하면, 경유지를 추가 할 수 있습니다.",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
    return Column(
      // Center + children 대신 Column 사용
      children: [
        // 1. 검색창 영역
        Padding(
          padding: const EdgeInsets.all(
            20.0,
          ), // AppSpacing.paddingLG 대신 일단 상수로 넣었습니다.
          child: TextField(
            decoration: InputDecoration(
              hintText: "지번, 도로명, 건물명으로 검색",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  // Controller 처리 로직
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ), // AppBorderRadius 대신 상수로 대체
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onSubmitted: (value) {
              // 검색 명령
            },
          ),
        ),

        // 2. 지도에서 주소 찾기 텍스트
        const Text(
          "현재 위치로 찾기",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

Widget _buildThirdStep() {
  final viewModel = Get.find<MapViewModel>();

  return Stack(
    children: [
      NaverMap(
        onMapReady: (controller) => viewModel.onMapReady(controller),
        onMapTapped: (point, latLng) {
          viewModel.handleMapTap(latLng);
        },
        onSymbolTapped: (symbol) {
    print("클릭한 건물: ${symbol.caption}, 좌표: ${symbol.position}");
    // 심볼의 위치(position)를 기존 좌표 처리 로직으로 넘깁니다.
    viewModel.handleMapTap(symbol.position, buildingName: symbol.caption);
        }
      ),

      
      // 주소 카드 레이어
      Obx(() => viewModel.currentAddress.value.isNotEmpty 
        ? Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: _buildAddressCard(viewModel),
          )
        : const SizedBox.shrink()),

      // 로딩 바
      Obx(() => viewModel.isLoading.value 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A2F4B))) 
        : const SizedBox.shrink()),
    ],
  );
}
Widget _buildAddressCard(MapViewModel viewModel) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("선택한 위치 정보", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const Divider(height: 24),
        
        // 🔥 여기가 핵심! Obx가 currentAddress의 변화를 감시해서 글자를 바꿔줍니다.
        Obx(() {// 주소와 건물명을 조합합니다.
  String displayAddress = viewModel.currentAddress.value;
  if (viewModel.currentBuildingName.value.isNotEmpty) {
    displayAddress += " (${viewModel.currentBuildingName.value})";
  }

  return Text(
    displayAddress.isNotEmpty ? displayAddress : "주소를 불러오는 중...",
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2F4B)),
  );}),
        
        const SizedBox(height: 16),
        
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // 4단계로 이동하며 주소 확정
              pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A2F4B), // coRunning 메인 컬러
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("이 장소로 설정", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}
Widget _buildFourthStep() => const Center(child: Text("마지막 단계 화면입니다."));


}


