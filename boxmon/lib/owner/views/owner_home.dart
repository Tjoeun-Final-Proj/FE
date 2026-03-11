import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:boxmon/core/components/owner_bottom_navigation.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:boxmon/owner/controllers/owner_home_controller.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class OwnerHomeView extends StatelessWidget {
  const OwnerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 컨트롤러 주입
    final controller = Get.put(OwnerHomeController());
    final tokenService = Get.find<TokenService>();
    final displayName =
        (tokenService.userName != null && tokenService.userName!.isNotEmpty)
        ? tokenService.userName!
        : '사용자';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavBar(),
      bottomNavigationBar: OwnerBottomNavigation(currentIndex: 0),

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
                  onTap: () => Get.offAllNamed('/owner/order'),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: const Color(0xFF434343),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedPackageSearch,
                          color: Colors.white,
                          size: 49,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "배차 검색",
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
                  onTap: () => Get.toNamed('/driver/inventory'),
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
                  onTap: () => Get.toNamed('/owner/wallet'),
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
                if (controller.isLoading.value) {
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

                if (controller.errorMessage.value != null) {
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
                          onPressed: controller.fetchTodaySummary,
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
                final int todayCount = summary?.todayScheduleCount ?? 0;
                final int inTransitCount = summary?.inTransitCount ?? 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedCalendar03,
                                color: Color(0xFF111827),
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "오늘의 운송 요약",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "실시간",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryItem(
                              label: "오늘 운행",
                              value: "${todayCount}건",
                              icon: HugeIcons.strokeRoundedTask01,
                              color: const Color(0xFF4B5563),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: const Color(0xFFE5E7EB),
                          ),
                          Expanded(
                            child: _buildSummaryItem(
                              label: "운송 중",
                              value: "${inTransitCount}건",
                              icon: HugeIcons.strokeRoundedTruck,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedClock01,
                              color: Color(0xFF6B7280),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "첫 상차 시간",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              controller.firstPickupText,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildNextShipmentCard(controller),
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

  Widget _buildNextShipmentCard(OwnerHomeController controller) {
    final hasNext = controller.hasNextShipment;
    final statusColor = _statusColor(controller.nextStatusText);
    final canOpenDetail = controller.nextShipmentId != null;

    return InkWell(
      onTap: hasNext && canOpenDetail
          ? () {
              Get.toNamed(
                AppRoutes.shipmentDetail,
                arguments: {'shipmentId': controller.nextShipmentId},
              );
            }
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: hasNext
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "다음 운송 1건",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.nextRouteText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          controller.nextStatusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.nextPickupText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      if (canOpenDetail)
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                    ],
                  ),
                ],
              )
            : const Text(
                "다음 운송이 없습니다",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
      ),
    );
  }

  Color _statusColor(String status) {
    final normalized = status.trim().toUpperCase();
    if (normalized == "IN_TRANSIT" || status.contains("운송")) {
      return const Color(0xFF2563EB);
    }
    if (normalized == "ASSIGNED" || status.contains("배차")) {
      return const Color(0xFF7C3AED);
    }
    if (normalized == "DONE" || status.contains("완료")) {
      return const Color(0xFF059669);
    }
    if (normalized == "CANCELED" ||
        normalized == "CANCELLED" ||
        status.contains("취소")) {
      return const Color(0xFFDC2626);
    }
    return const Color(0xFF4B5563);
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required dynamic icon,
    required Color color,
  }) {
    return Column(
      children: [
        HugeIcon(icon: icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
