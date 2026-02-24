import 'dart:io';

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
            ElevatedButton(
              onPressed: () {
                // 텍스트 내용 저장
                viewModel.cargoDescription.value = textController.text;
                Get.back(); // 메인 화면으로 복귀
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

  // 사진 첨부 영역 위젯
  Widget _buildPhotoArea(MapViewModel viewModel) {
    return Obx(() => SizedBox(
      height: 100, // 사진 영역 높이 고정
      child: Row(
        children: [
          // 사진 추가 버튼
          InkWell(
            onTap: viewModel.pickCargoImages,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text("${viewModel.cargoImages.length}/5", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 선택된 사진 리스트 (가로 스크롤)
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.cargoImages.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(viewModel.cargoImages[index].path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 삭제 버튼 (X 표시)
                    Positioned(
                      top: -8,
                      right: -8,
                      child: GestureDetector(
                        onTap: () => viewModel.removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}