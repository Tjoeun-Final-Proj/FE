import 'package:boxmon/owner/controllers/inquery_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyInqueryView extends StatelessWidget {
  const MyInqueryView({super.key});

  @override
  Widget build(BuildContext context) {
    // 문의하기에서 썼던 컨트롤러 그대로 사용 (목록 로드 함수가 있다고 가정)
    final controller = Get.put(InqueryController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // 연한 회색 배경으로 카드 부각
      appBar: AppBar(
        title: const Text(
          "내 문의 내역",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return null;
          },
        );
      }),
      // 우측 하단 플로팅 버튼으로 바로 문의하기 이동 가능하게!
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/my-inquery'), // 아까 만든 작성 페이지로 이동
        backgroundColor: const Color(0xFF1A2F4B),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  // --- 문의 내역 카드 위젯 ---
  Widget _buildInqueryCard(dynamic item) {
    // 답변 여부에 따른 색상 정의
    bool isReplied = item.replyContent != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              _buildStatusBadge(isReplied),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.content ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: Text(
              DateFormat('yyyy.MM.dd HH:mm').format(item.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
          // 펼쳤을 때 보여줄 내용
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 15),
                  const Text(
                    "문의 내용",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.content ?? "",
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),

                  if (isReplied) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.subdirectory_arrow_right,
                                size: 16,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "답변 완료",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.replyContent!,
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 답변 상태 배지 ---
  Widget _buildStatusBadge(bool isReplied) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isReplied ? const Color(0xFFE3F2FD) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isReplied ? "답변완료" : "답변대기",
        style: TextStyle(
          color: isReplied ? const Color(0xFF1976D2) : Colors.grey[600],
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- 문의 내역 없을 때 화면 ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_late_outlined,
            size: 60,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            "문의하신 내역이 없습니다.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

