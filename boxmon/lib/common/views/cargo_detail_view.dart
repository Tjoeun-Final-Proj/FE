import 'package:boxmon/map/model/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CargoDetailView extends StatelessWidget {
  const CargoDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<MapViewModel>();
    // 기존에 입력했던 내용이 있다면 불러오기
    final textController = TextEditingController(text: viewModel.cargoDescription.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text("짐 내용 · 요청사항"),
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 내림
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 1️⃣ 사진 첨부 섹션
            _buildSectionTitle("짐 사진 첨부 (선택)"),
            const SizedBox(height: 10),
            _buildPhotoArea(viewModel),

            const SizedBox(height: 30),

            // 2️⃣ 운반 환경 섹션 (층수, 엘리베이터)

            // 3️⃣ 상세 내용 입력 섹션
            _buildSectionTitle("상세 내용 및 요청사항"),
            const SizedBox(height: 10),
            TextField(
              controller: textController,
              maxLines: 5,
              maxLength: 200, // 글자 수 제한
              decoration: InputDecoration(
                hintText: "예: 양문형 냉장고 1개, 3인용 소파 1개 있습니다.\n기사님 도움이 필요합니다.",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            const SizedBox(height: 40),

            // 완료 버튼
            // 완료 버튼 수정
ElevatedButton(
  onPressed: () {
    // 1. 텍스트 내용 저장
    viewModel.cargoDescription.value = textController.text;
    
    // 🔍 [로그] 제대로 담겼는지 확인용
    print("✅ 상세내용 저장됨: ${viewModel.cargoDescription.value}");
    print("📸 사진 저장됨: ${viewModel.selectedCargoImage.value?.path ?? '없음'}");
    
    // 2. 메인 화면으로 복귀 (이제 메인 화면의 '전송' 버튼에서 이 값을 꺼내 쓰면 됩니다!)
    Get.back(); 
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF1A2F4B),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: const Text("입력 완료", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
),
          ],
        ),
      ),
    );
  }

  // 섹션 제목 위젯
  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  // 사진 첨부 영역 위젯 (CargoDetailView 내부 교체)
  Widget _buildPhotoArea(MapViewModel viewModel) {
    return Obx(() {
      final imageFile = viewModel.selectedCargoImage.value;
      
      return SizedBox(
        height: 100,
        child: imageFile == null 
          // 1. 사진이 없을 때: 카메라 버튼 하나만 보여줌
          ? InkWell(
              onTap: viewModel.pickSingleCargoImage,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, color: Colors.grey),
                    SizedBox(height: 4),
                    Text("사진 첨부", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            )
          // 2. 사진이 있을 때: 고른 사진과 삭제(X) 버튼만 보여줌
          : Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    imageFile,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -8,
                  right: -8,
                  child: GestureDetector(
                    onTap: viewModel.removeImage,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
      );
    });
  }
  }