import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/common_bottom_navigation.dart';
import 'package:boxmon/common/controller/common_home_controller.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class CommonHomeView extends StatelessWidget {
  const CommonHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommonHomeController());
    final tokenService = Get.find<TokenService>();
    final displayName =
        (tokenService.userName != null && tokenService.userName!.isNotEmpty)
        ? tokenService.userName!
        : '사용자';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavBar(),
      bottomNavigationBar: CommonBottomNavigation(currentIndex: 0),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            Text(
              "$displayName님",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text(
              "오늘 어떤 물건을 보내실 건가요?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 10),

            // ⭐ 메뉴 버튼 3개 전부 직작성
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// 배차 요청
                InkWell(
                  onTap: () => Get.toNamed('/common/start/package'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F5AA6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedInvoice01,
                          color: Colors.white,
                          size: 49,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "배차 요청",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 운송 현황
                InkWell(
                  onTap: () => Get.toNamed('/shipper/inventory'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedTruck,
                          color: Colors.black87,
                          size: 49,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "운송 현황",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 정산 관리
                InkWell(
                  onTap: () => Get.toNamed('/common/wallet'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedWallet02,
                          color: Colors.black87,
                          size: 49,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "정산 관리",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.summary.value == null) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E4E4)),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.errorMessage.value != null &&
                    controller.summary.value == null) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E4E4)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.errorMessage.value!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: controller.fetchShipperSummary,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0055AB),
                          ),
                          child: const Text(
                            "다시 시도",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final summary = controller.summary.value;
                final int requestedCount = summary?.requestedCount ?? 0;
                final int assignedCount = summary?.assignedCount ?? 0;
                final int inTransitCount = summary?.inTransitCount ?? 0;
                final int doneCount = summary?.doneCount ?? 0;
                final recent = controller.recentShipment.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "배송 요약",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "전체 보기",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              label: "배차 대기",
                              count: requestedCount,
                              color: const Color(0xFF64748B),
                              icon: HugeIcons.strokeRoundedClock01,
                              bgColor: const Color(0xFFF8FAFC),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              label: "배차 완료",
                              count: assignedCount,
                              color: const Color(0xFF2563EB),
                              icon: HugeIcons.strokeRoundedUserCheck01,
                              bgColor: const Color(0xFFEFF6FF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              label: "운송 중",
                              count: inTransitCount,
                              color: const Color(0xFF1D4ED8),
                              icon: HugeIcons.strokeRoundedTruck,
                              bgColor: const Color(0xFFEEF2FF),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSummaryCard(
                              label: "배송 완료",
                              count: doneCount,
                              color: const Color(0xFF059669),
                              icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                              bgColor: const Color(0xFFECFDF5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildRecentShipmentCard(
                        routeText: recent?.routeText,
                        shipmentStatus: recent?.shipmentStatus,
                        lastUpdatedLabel: recent?.lastUpdatedLabel,
                      ),
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required int count,
    required Color color,
    required dynamic icon,
    required Color bgColor,
  }) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: HugeIcon(
                  icon: icon,
                  color: color,
                  size: 20,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$count",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: -1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 2),
                child: Text(
                  "건",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentShipmentCard({
    required String? routeText,
    required String? shipmentStatus,
    required String? lastUpdatedLabel,
  }) {
    final bool hasRecentData =
        (routeText != null && routeText.isNotEmpty) &&
        (shipmentStatus != null && shipmentStatus.isNotEmpty) &&
        (lastUpdatedLabel != null && lastUpdatedLabel.isNotEmpty);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: hasRecentData
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "최근 운송 내역",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  routeText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  shipmentStatus,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lastUpdatedLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            )
          : const Text(
              "최근 운송 내역이 없습니다",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
    );
  }
}

