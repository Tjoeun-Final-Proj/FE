import 'dart:io';

import 'package:boxmon/owner/controllers/inquery_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InqueryView extends StatelessWidget {
  const InqueryView({super.key});
  // 🎯 Get.find로 컨트롤러 연결 (상위에서 put이 먼저 되어있어야 함)

  @override
  Widget build(BuildContext context) {
    final InqueryController inqueryController = Get.put(InqueryController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("1:1 문의하기"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 1️⃣ 사진 첨부 섹션
            _buildSectionTitle("문의 사진 첨부 (선택)"),
            const SizedBox(height: 10),
            _buildPhotoArea(), // 인자를 넘기지 않고 내부에서 컨트롤러 참조

            const SizedBox(height: 30),

            // 2️⃣ 상세 내용 입력 섹션
            _buildSectionTitle("상세 내용"),
            const SizedBox(height: 10),
            TextField(
              controller: inqueryController.contentController,
              maxLines: 8,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: "문의하실 내용을 상세히 적어주세요.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            const SizedBox(height: 40),

            // 3️⃣ 완료 버튼 (서버 전송 로직 연결)
            Obx(
              () => ElevatedButton(
                onPressed: inqueryController.isLoading.value
                    ? null
                    : () => inqueryController.submit(), // 컨트롤러의 submit 호출
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2F4B),
                  minimumSize: const Size(double.infinity, 56), // 꽉 찬 버튼
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: inqueryController.isLoading.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "문의 등록 완료",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  // 🎯 사진 첨부 영역 (리스트 구조 최적화)
  Widget _buildPhotoArea() {
    final InqueryController inqueryController = Get.find<InqueryController>();

    return Obx(() {
      // Obx 내부에서 .length를 호출함으로써 상태 변화를 감지함
      final images = inqueryController.imagePath;

      return SizedBox(
        height: 100,
        child: Row(
          children: [
            // 사진 추가 버튼
            InkWell(
              onTap: () => inqueryController.pickImage(), // 실제 사진 선택 함수 호출
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
                    Text(
                      "${images.length}/5",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 선택된 사진 리스트
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(images[index]), // 리스트에서 경로를 꺼내 파일 생성
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // 삭제 버튼
                      Positioned(
                        top: -8,
                        right: -8,
                        child: GestureDetector(
                          onTap: () => inqueryController.removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
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
      );
    });
  }
}
